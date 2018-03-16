//
//  BYMailController.m
//  缘邮
//
//  Created by LiLu on 16/2/18.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMailController.h"
#import "BYMailParam.h"
#import "BYMailResult.h"
#import "BYMailTool.h"
#import "BYPagination.h"
#import "BYMail.h"
#import "BYMailTitleCell.h"
#import "BYMailDetailParam.h"
#import "BYMailDetailController.h"
#import "BYSendMailController.h"
#import "BYDeleteMailParam.h"

#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"

@interface BYMailController () <UITableViewDataSource, UITableViewDelegate>

- (IBAction)mailSelected:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//保存邮件
@property (nonatomic, strong) NSMutableArray *mails;

//保存分页信息
@property (nonatomic, strong) BYPagination *pagination;

//保存请求mail的参数信息
@property (nonatomic, strong) BYMailParam *param;

@end

@implementation BYMailController

- (NSMutableArray *)mails{
    if (!_mails) {
        _mails = [NSMutableArray array];
    }
    return _mails;
}

- (BYPagination *)pagination{
    if (!_pagination) {
        _pagination = [[BYPagination alloc] init];
    }
    return _pagination;
}

- (BYMailParam *)param{
    if (!_param) {
        _param = [BYMailParam param];
    }
    return _param;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置右边写邮件的按钮
    [self setUpRightBarButtonItem];
    
    //进入界面先加载收件箱的信件
    [self loadMailFromInbox];
    
    //添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(loadMailForHeaderRefreshing)];
    
    //添加上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(loadMailForFooterRefreshing)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self loadMailWhenBack];
}

#pragma mark 处理邮件加载

//从上一个界面返回时静默刷新
- (void)loadMailWhenBack{
    
    [BYMailTool loadMailWithParam:self.param whenSuccess:^(BYMailResult *mailResult) {
        //遍历数组拿到模型,添加到数组里
        [self.mails removeAllObjects];
        
        for (BYMail *mail in mailResult.mail) {
            [self.mails addObject:mail];
        }
        
        //拿到分页信息
        self.pagination = mailResult.pagination;
        
        //刷新tableView
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];

}

//进入界面先刷新一次
- (void)loadMail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BYMailTool loadMailWithParam:self.param whenSuccess:^(BYMailResult *mailResult) {
        //遍历数组拿到模型,添加到数组里
        [self.mails removeAllObjects];
        
        for (BYMail *mail in mailResult.mail) {
            [self.mails addObject:mail];
        }
        
        //拿到分页信息
        self.pagination = mailResult.pagination;
        
        //刷新tableView
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"获取信件失败"];
    }];
}

//头部,下拉刷新
- (void)loadMailForHeaderRefreshing{
    self.param.page = 1;
    
    [BYMailTool loadMailWithParam:self.param whenSuccess:^(BYMailResult *mailResult) {
        
        //停止刷新
        [self.tableView headerEndRefreshing];
        
        //遍历数组拿到模型,添加到数组里
        [self.mails removeAllObjects];
        
        for (BYMail *mail in mailResult.mail) {
            [self.mails addObject:mail];
        }
        
        //拿到分页信息
        self.pagination = mailResult.pagination;
        
        //刷新tableView
        [MBProgressHUD showSuccess:@"加载成功"];
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        BYLog(@"%@", error);
        [MBProgressHUD showError:@"获取信件失败"];
    }];
}

//尾部,上拉刷新
- (void)loadMailForFooterRefreshing{
    //请求更多数据
    if (self.param.page < self.pagination.page_all_count) {
        self.param.page++;
        [BYMailTool loadMailWithParam:self.param whenSuccess:^(BYMailResult *mailResult) {
            
            //停止刷新
            [self.tableView footerEndRefreshing];
            
            //遍历数组拿到模型,添加到数组里
            //注意:下拉刷新就不再清空mails了,直接添加到尾部即可
//            [self.mails removeAllObjects];
            
            for (BYMail *mail in mailResult.mail) {
                [self.mails addObject:mail];
            }
            
            //拿到分页信息
            self.pagination = mailResult.pagination;
            
            //刷新tableView
            [MBProgressHUD showSuccess:@"加载成功"];
            [self.tableView reloadData];
        } whenFailure:^(NSError *error) {
            [self.tableView footerEndRefreshing];
            BYLog(@"%@", error);
            [MBProgressHUD showError:@"获取信件失败"];
        }];
    }else{
        [self.tableView footerEndRefreshing];
        [MBProgressHUD showSuccess:@"已显示全部"];
    }
}

//从收件箱获取邮件
- (void)loadMailFromInbox{
    self.param.page = 1;
    self.param.box = @"inbox";
    [self loadMail];
}

//从发件箱获取邮件
- (void)loadMailFromOutBox{
    self.param.page = 1;
    self.param.box = @"outbox";
    [self loadMail];
}

//从回收站获取邮件
- (void)loadMailFromDeleted{
    self.param.page = 1;
    self.param.box = @"deleted";
    [self loadMail];
}


#pragma mark tableView代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"mailTitleCell";
    
    BYMailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    BYMail *mail = self.mails[indexPath.row];
    
    cell.mail = mail;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //得到邮件数据
    BYMail *mail = self.mails[indexPath.row];
    
    //创建参数
    BYMailDetailParam *param = [BYMailDetailParam param];
    
    //赋值,给出是哪个信箱
    param.box = self.param.box;
    
    //第几个
    param.num = mail.index;
    
    //进入邮件具体信息界面
    BYMailDetailController *mailDetailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailDetail"];
    mailDetailVc.param = param;
    [self.navigationController pushViewController:mailDetailVc animated:YES];
}

//删除事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark tableView 删除事件
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        BYLog(@"点击了:%ld", (long)indexPath.row);
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //获得到对应的模型
        BYMail *mail = self.mails[indexPath.row];
        
        //创建删除邮件需要的参数
        BYDeleteMailParam *param = [BYDeleteMailParam param];
        param.box = self.param.box;
        param.num = mail.index;
        
        [BYMailTool deleteMailWithParam:param whenSuccess:^(BYMail *deleteMail) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"删除成功"];
            [self loadMail];
        } whenFailure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:@"删除失败"];
        }];
    }];
    return @[deleteRowAction];
}

#pragma mark 写邮件事件处理
- (void)setUpRightBarButtonItem{
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeMail)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
}

- (void)writeMail{
//    BYLog(@"写邮件");
    BYSendMailController *sendMailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sendMail"];
    [self.navigationController pushViewController:sendMailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mailSelected:(UISegmentedControl *)sender {
    self.navigationItem.title = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    switch (sender.selectedSegmentIndex) {
        case 0:
            //收件箱
            [self loadMailFromInbox];
            break;
            
        case 1:
            //发件箱
            [self loadMailFromOutBox];
            break;
        case 2:
            //回收站
            [self loadMailFromDeleted];
            break;
            
        default:
            break;
    }
}

@end
