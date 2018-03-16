//
//  BYMessageController.m
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMessageController.h"
#import "BYMessageCell.h"
#import "BYMessageParam.h"
#import "BYMessageResult.h"
#import "BYMessageTool.h"
#import "BYPagination.h"
#import "BYMessage.h"
#import "BYMsgDetailParam.h"
#import "BYArticle.h"
#import "BYArticleFrame.h"
#import "BYMsgDetailController.h"
#import "BYSetMsgReadParam.h"

#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface BYMessageController ()<UITableViewDataSource, UITableViewDelegate>
- (IBAction)messageSelected:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//保存邮件
@property (nonatomic, strong) NSMutableArray *messages;

//保存分页信息
@property (nonatomic, strong) BYPagination *pagination;

//保存请求mail的参数信息
@property (nonatomic, strong) BYMessageParam *param;

@end

@implementation BYMessageController

- (NSMutableArray *)messages{
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (BYPagination *)pagination{
    if (!_pagination) {
        _pagination = [[BYPagination alloc] init];
    }
    return _pagination;
}

- (BYMessageParam *)param{
    if (!_param) {
        _param = [BYMessageParam param];
    }
    return _param;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //进入界面先加载回复我的文章
    [self loadMessageFromReply];
    
    //添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(loadMailForHeaderRefreshing)];
    
    //添加上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(loadMailForFooterRefreshing)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self loadMessageWhenBack];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 处理提醒加载
//从上一个界面返回时静默刷新
- (void)loadMessageWhenBack{
    
}

//上拉刷新
- (void)loadMailForFooterRefreshing{
    //请求更多数据
    if (self.param.page < self.pagination.page_all_count) {
        self.param.page++;
        [BYMessageTool loadMessageWithParam:self.param whenSuccess:^(BYMessageResult *msgResult) {
            
            //停止刷新
            [self.tableView footerEndRefreshing];
            
            //遍历数组拿到模型,添加到数组里
            //注意:下拉刷新就不再清空mails了,直接添加到尾部即可
            //            [self.mails removeAllObjects];
            
            for (BYMessage *msg in msgResult.article) {
                [self.messages addObject:msg];
            }
            
            //拿到分页信息
            self.pagination = msgResult.pagination;
            
            //刷新tableView
            [MBProgressHUD showSuccess:@"加载成功"];
            [self.tableView reloadData];
        } whenFailure:^(NSError *error) {
            [self.tableView footerEndRefreshing];
            BYLog(@"%@", error);
            [MBProgressHUD showError:@"获取提醒失败"];
        }];
    }else{
        [self.tableView footerEndRefreshing];
        [MBProgressHUD showSuccess:@"已显示全部"];
    }

}

//下拉刷新
- (void)loadMailForHeaderRefreshing{
    self.param.page = 1;
    
    [BYMessageTool loadMessageWithParam:self.param whenSuccess:^(BYMessageResult *msgResult) {
        
        //停止刷新
        [self.tableView headerEndRefreshing];
        
        //遍历数组拿到模型,添加到数组里
        [self.messages removeAllObjects];
        
        for (BYMessage *msg in msgResult.article) {
            [self.messages addObject:msg];
        }
        
        //拿到分页信息
        self.pagination = msgResult.pagination;
        
        //刷新tableView
        [MBProgressHUD showSuccess:@"加载成功"];
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        BYLog(@"%@", error);
        [MBProgressHUD showError:@"获取提醒失败"];
    }];

}

- (void)loadMessage{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BYMessageTool loadMessageWithParam:self.param whenSuccess:^(BYMessageResult *msgResult) {
        //遍历数组拿到模型,添加到数组里
        [self.messages removeAllObjects];
        
        for (BYMessage *msg in msgResult.article) {
            [self.messages addObject:msg];
        }
        
        //拿到分页信息
        self.pagination = msgResult.pagination;
        
        //刷新tableView
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"获取提醒失败"];
    }];

}

#pragma mark tableView代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"messageCell";
    
    BYMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    BYMessage *msg = self.messages[indexPath.row];
    msg.type = self.param.type;
    
    cell.message = msg;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //取出模型
    BYMessage *msg = self.messages[indexPath.row];
    
    //设置参数
    BYMsgDetailParam *param = [BYMsgDetailParam param];
    param.name = msg.board_name;
    param.BYid = msg.BYid;
//    BYLog(@"楼层%d", msg.pos);
    
    //设置标记为已读
    BYSetMsgReadParam *setMsgReadParam = [BYSetMsgReadParam param];
    setMsgReadParam.type = self.param.type;
    setMsgReadParam.index = msg.index;
    [BYMessageTool setMsgReadWithParam:setMsgReadParam whenSuccess:^(BYArticle *msg) {
        //这里得到的就是具体消息
        [BYMessageTool loadMsgDetailWithParam:param whenSuccess:^(BYArticle *msgDetail) {
            BYMsgDetailController *msgVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"msgDetail"];
            BYArticleFrame *articleFrame = [[BYArticleFrame alloc] init];
            articleFrame.article = msgDetail;
            
            msgVc.articleFrame = articleFrame;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController pushViewController:msgVc animated:YES];
        } whenFailure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:@"原文章已删除"];
            BYLog(@"%@", error);
        }];
    } whenFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        BYLog(@"%@", error);
    }];
}

//删除事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark tableView 删除事件
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        BYLog(@"点击了:%ld", (long)indexPath.row);
        //取出模型
        BYMessage *msg = self.messages[indexPath.row];
        BYSetMsgReadParam *deleteParam = [BYSetMsgReadParam param];
        deleteParam.type = self.param.type;
        deleteParam.index = msg.index;
        [BYMessageTool deleteMsgWithParam:deleteParam whenSuccess:^(BYArticle *msg) {
            if (msg) {
                [MBProgressHUD showSuccess:@"删除成功"];
                [self.messages removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
        } whenFailure:^(NSError *error) {
            BYLog(@"%@", error);
            [MBProgressHUD showError:@"删除失败"];
        }];
    }];
    return @[deleteRowAction];
}


- (IBAction)messageSelected:(UISegmentedControl *)sender {
    self.navigationItem.title = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    switch (sender.selectedSegmentIndex) {
        case 0:
            //回复我的文章
            [self loadMessageFromReply];
            break;
        case 1:
            //@我的文章
            [self loadMessageFromAt];
            break;
            
        default:
            break;
    }
}

//回复我的文章
- (void)loadMessageFromReply{
    self.param.type = @"reply";
    [self loadMessage];
}

//@我的文章
- (void)loadMessageFromAt{
    self.param.type = @"at";
    [self loadMessage];
}
@end
