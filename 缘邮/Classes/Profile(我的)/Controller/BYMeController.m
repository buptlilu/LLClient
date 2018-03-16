//
//  BYMeController.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYMeController.h"
#import "BYMeCell.h"
#import "BYBaseSetting.h"
#import "BYMeTool.h"
#import "BYMeResult.h"
#import "BYUser.h"
#import "BYMeInfoCell.h"
#import "BYMeInfoFrame.h"
#import "BYMeDetailController.h"
#import "BYMailController.h"
#import "BYMailTool.h"
#import "BYMailParam.h"
#import "BYMail.h"
#import "BYMailResult.h"
#import "BYMessageController.h"
#import "BYTestController.h"
#import "BYCollectionController.h"
#import "BYMessageTool.h"
#import "BYNewCountResult.h"
#import "BYLabelItem.h"
#import "BYAccountTool.h"
#import "BYAccount.h"
#import "AppDelegate.h"
#import "BYSendMailController.h"
#import "BYReplyMailParam.h"
#import "BYSendMailParam.h"
#import "BYOAuthController.h"
#import "RDVTabBarItem.h"

#import "UIBarButtonItem+Item.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"


@interface BYMeController ()<UIActionSheetDelegate, UIAlertViewDelegate, BYSettingCellDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BYMeInfoFrame *meInfoFrame;

/**
 *  获取最新邮件数量需要的参数
 */
@property(nonatomic, strong) BYMailParam *param;

/**
 *  最新邮件数量
 */
@property(nonatomic, assign) int lastMailCount;

/**
 *  最新回复我的文章的数量
 */
@property(nonatomic, assign) int lastReplyMeCount;

/**
 *  最新@我的文章的数量
 */
@property(nonatomic, assign) int lastAtMeCount;

/**
 *  默认为0, 1代表清除缓存, 2代表退出登录
 */
@property (nonatomic, assign) int actionSheetType;
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation BYMeController

- (BYMailParam *)param{
    if (!_param) {
        _param = [BYMailParam param];
        _param.count = 1;
        _param.page = 1;
    }
    return _param;
}

- (BYMeInfoFrame *)meInfoFrame{
    if (!_meInfoFrame) {
        _meInfoFrame = [[BYMeInfoFrame alloc] init];
    }
    return _meInfoFrame;
}

#pragma mark - life cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    
    //进入界面先加载一次个人信息
    [self loadMeInfo];
    
//    self.tabBarItem.badgeValue = @"10";
    
    //添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadMeInfoForHeaderRefreshing)];
    
//    [shareBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchUser)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    BYLog(@"view将消失");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    BYLog(@"view将出现");
    
    //获取提醒消息
    [self loadNewCount];
}

#pragma mark - functions
- (void)setUpViews {
    //    [DKNightVersionManager nightFalling];
    [self setUpNavBarTitleView:@"我的"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - kTopBarHeight - kStatusBarHeight) style:UITableViewStyleGrouped];
    tableView.dk_backgroundColorPicker = DKColor_BACKGROUND_Setting;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
}

- (void)searchUser{
//    BYTestController *testVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"testVc"];
//    [self.navigationController pushViewController:testVc animated:YES];
//    return;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"查询用户" message:@"请输入要查询的用户ID" delegate:self cancelButtonTitle:@"查询" otherButtonTitles:@"取消", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        return;
    }
    
    UITextField *inputTextField = [alertView textFieldAtIndex:0];
    
    //得到用户输入的要查询的userID
    NSString *inputUserId = inputTextField.text;
    
    [MBProgressHUD showMessage:@"正在查询" toView:self.view];
    
    [BYMeTool loadUserInfoWithUserId:inputUserId whenSuccess:^(BYMeResult *userInfo) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (userInfo != nil) {
            //进入个人信息控制器展示
            BYMeDetailController *meDetailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MeDetail"];
            meDetailVc.meInfo = userInfo;
            [self.navigationController pushViewController:meDetailVc animated:YES];
//            BYLog(@"查询成功");
        }

    } whenFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"未找到用户信息"];
    }];
}


-(void)loadMeInfoForHeaderRefreshing{
    [BYMeTool loadMeInfoWhenSuccess:^(BYMeResult *meInfo) {
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        
        self.meInfoFrame.meInfo = meInfo;
        
        [MBProgressHUD showSuccess:@"加载成功"];
        
        //刷新表格
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        [MBProgressHUD showError:@"加载失败"];
        BYLog(@"%@", error);
    }];
    
    //获取提醒消息
    [self loadNewCount];
}

-(void)loadMeInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BYMeTool loadMeInfoWhenSuccess:^(BYMeResult *meInfo) {
        self.meInfoFrame.meInfo = meInfo;
        //刷新表格
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败"];
        BYLog(@"%@", error);
    }];
    
    //获取提醒消息
    [self loadNewCount];
}

//获取最新消息并且发送通知
-(void)loadNewCountAndNote{
    [BYMailTool loadMailWithParam:self.param whenSuccess:^(BYMailResult *mailResult) {
        
        //判断当前联网获得的最新邮件时间参数是否大于记录的最新邮件参数
        if (self.lastMailCount < mailResult.new_num) {
            //1.创建本地通知
            UILocalNotification *localNote = [[UILocalNotification alloc] init];
            
            //1.1设置什么时间弹出
            localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
            
            //1.2设置弹出内容
            localNote.alertBody = [NSString stringWithFormat:@"您有%d封新邮件", mailResult.new_num];
            
            //1.3设置锁屏状态下显示的文字
            localNote.alertAction = @"查看";
            
            //1.4是否显示alertAction文字,默认是YES，设置为NO就不显示了
            localNote.hasAction = YES;
            
            //1.5显示启动图片
            localNote.alertLaunchImage = [NSString stringWithFormat:@"%d", mailResult.new_num + self.lastAtMeCount + self.lastReplyMeCount];
            
            //1.6设置音效
            localNote.soundName = UILocalNotificationDefaultSoundName;
            
            //1.7应用图标右上角的体现数字
            localNote.applicationIconBadgeNumber = mailResult.new_num;
            
            //1.8设置UserInfo来传递信息
            localNote.userInfo = @{@"alertBody" : localNote.alertBody, @"applicationIconBadgeNumber" : @(localNote.applicationIconBadgeNumber)};
            
            //2.调度通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
        }

        //获取最新邮件数量
//        BYLog(@"未读邮件数:%d", mailResult.new_num);
        self.lastMailCount = mailResult.new_num;
        
        //更新tabbar图标提醒数量
        [self updateBadgeValue];
        
        //更新app图标提醒数量
        [UIApplication sharedApplication].applicationIconBadgeNumber =  self.lastMailCount + self.lastReplyMeCount + self.lastAtMeCount;
        
        //刷新表格
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //获取最新回复我的文章的数量
    [BYMessageTool loadNewReplyMeMsgCountWhenSuccess:^(BYNewCountResult *newCountResult) {
        
        //如果最新获得的数量比当前保存的大,就发送通知,否则不发送
        if (self.lastReplyMeCount < newCountResult.new_count) {
            //1.创建本地通知
            UILocalNotification *localNote = [[UILocalNotification alloc] init];
            
            //1.1设置什么时间弹出
            localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
            
            //1.2设置弹出内容
            localNote.alertBody = [NSString stringWithFormat:@"您有%d封新回复的文章", newCountResult.new_count];
            
            //1.3设置锁屏状态下显示的文字
            localNote.alertAction = @"查看";
            
            //1.4是否显示alertAction文字,默认是YES，设置为NO就不显示了
            localNote.hasAction = YES;
            
            //1.5显示启动图片
            localNote.alertLaunchImage = [NSString stringWithFormat:@"%d", newCountResult.new_count + self.lastAtMeCount + self.lastMailCount];
            
            //1.6设置音效
            localNote.soundName = UILocalNotificationDefaultSoundName;
            
            //1.7应用图标右上角的体现数字
            localNote.applicationIconBadgeNumber = newCountResult.new_count;
            
            //1.8设置UserInfo来传递信息
            localNote.userInfo = @{@"alertBody" : localNote.alertBody, @"applicationIconBadgeNumber" : @(localNote.applicationIconBadgeNumber)};
            
            //2.调度通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
        }
        
        self.lastReplyMeCount = newCountResult.new_count;
        //刷新表格
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //tabbarItem的值
        [self updateBadgeValue];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = self.lastMailCount + self.lastReplyMeCount + self.lastAtMeCount;
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //获取最新@我的文章的数量
    [BYMessageTool loadNewAtMeMsgCountWhenSuccess:^(BYNewCountResult *newCountResult) {
        
        //如果最新获得的数量比当前保存的大,就发送通知,否则不发送
        if (self.lastAtMeCount < newCountResult.new_count) {
            //1.创建本地通知
            UILocalNotification *localNote = [[UILocalNotification alloc] init];
            
            //1.1设置什么时间弹出
            localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
            
            //1.2设置弹出内容
            localNote.alertBody = [NSString stringWithFormat:@"您有%d封@我的文章", newCountResult.new_count];
            
            //1.3设置锁屏状态下显示的文字
            localNote.alertAction = @"查看";
            
            //1.4是否显示alertAction文字,默认是YES，设置为NO就不显示了
            localNote.hasAction = YES;
            
            //1.5显示启动图片
            localNote.alertLaunchImage = [NSString stringWithFormat:@"%d", newCountResult.new_count + self.lastReplyMeCount + self.lastMailCount];
            
            //1.6设置音效
            localNote.soundName = UILocalNotificationDefaultSoundName;
            
            //1.7应用图标右上角的体现数字
            localNote.applicationIconBadgeNumber = newCountResult.new_count;
            
            //1.8设置UserInfo来传递信息
            localNote.userInfo = @{@"alertBody" : localNote.alertBody, @"applicationIconBadgeNumber" : @(localNote.applicationIconBadgeNumber)};
            
            //2.调度通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
        }

        
        self.lastAtMeCount = newCountResult.new_count;
        //刷新表格
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //tabbarItem的值
        [self updateBadgeValue];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = self.lastMailCount + self.lastReplyMeCount + self.lastAtMeCount;
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
}

//获取最新消息
- (void)loadNewCount{
    //获取最新邮件数
    [BYMailTool loadMailWithParam:self.param whenSuccess:^(BYMailResult *mailResult) {
        self.lastMailCount = mailResult.new_num;
        //刷新表格
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //tabbarItem的值
        [self updateBadgeValue];

        [UIApplication sharedApplication].applicationIconBadgeNumber = self.lastMailCount + self.lastReplyMeCount + self.lastAtMeCount;
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //获取最新回复我的文章的数量
    [BYMessageTool loadNewReplyMeMsgCountWhenSuccess:^(BYNewCountResult *newCountResult) {
        self.lastReplyMeCount = newCountResult.new_count;
        //刷新表格
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //tabbarItem的值
        [self updateBadgeValue];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = self.lastMailCount + self.lastReplyMeCount + self.lastAtMeCount;
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //获取最新@我的文章的数量
    [BYMessageTool loadNewAtMeMsgCountWhenSuccess:^(BYNewCountResult *newCountResult) {
        self.lastAtMeCount = newCountResult.new_count;
        //刷新表格
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //tabbarItem的值
        [self updateBadgeValue];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = self.lastMailCount + self.lastReplyMeCount + self.lastAtMeCount;
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
}

- (void)updateBadgeValue {
    RDVTabBarItem *item = [[[self.rdv_tabBarController tabBar] items] objectAtIndex:3];
    int count = self.lastMailCount + self.lastReplyMeCount + self.lastAtMeCount;
    NSString *str = @"";
    if (count > 0) {
        str = [NSString stringWithFormat:@"%d", self.lastMailCount + self.lastReplyMeCount + self.lastAtMeCount];
    }
    item.badgeValue = str;
}

#pragma mark tableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BYMeInfoCell *cell = [BYMeInfoCell cellWithTableView:tableView];
        
        cell.meInfoFrame = self.meInfoFrame;
        return cell;
    }
    
    else if (indexPath.section == 1){
        BYSettingCell *cell = [BYSettingCell cellWithTableView:tableView];
        cell.spaceView.hidden = NO;
        if (indexPath.row == 0) {
            BYBadgeItem *item = [BYBadgeItem itemWithImage:[UIImage imageNamed:@"email_24pt"] title:@"我的收件箱"];
            item.badgeValue = [NSString stringWithFormat:@"%d", self.lastMailCount];
            cell.item = item;
        }
        if (indexPath.row == 1) {
            BYBadgeItem *item = [BYBadgeItem itemWithImage:[UIImage imageNamed:@"huifuwo_24pt"] title:@"文章消息提醒"];
            item.badgeValue = [NSString stringWithFormat:@"%d", self.lastAtMeCount + self.lastReplyMeCount];
            cell.item = item;
        }
        if (indexPath.row == 2) {
            BYArrowItem *item = [BYArrowItem itemWithImage:[UIImage imageNamed:@"shouluwenzhang_24pt"] title:@"我收录的文章"];
            cell.item = item;
            cell.spaceView.hidden = YES;
        }
        return cell;
    }
    
    else if (indexPath.section == 2){
        BYSettingCell *cell = [BYSettingCell cellWithTableView:tableView];
        cell.spaceView.hidden = NO;
//        if (indexPath.row == 0) {
//            BYSwitchItem *item = [BYSwitchItem itemWithImage:[UIImage imageNamed:@"new_friend"] title:@"有新消息时推送通知"];
//            cell.delegate = self;
//            cell.item = item;
//        }
//        
        if (indexPath.row == 0){
            BYArrowItem *item = [BYArrowItem itemWithImage:[UIImage imageNamed:@"huancun_24pt"] title:@"清除缓存"];
            //获取SDWebImage的缓存
            NSUInteger size = [[SDImageCache sharedImageCache] getSize];
            
            NSString *title = nil;
            if (size > 1024 * 1024) {
                CGFloat floatSize = size / 1024.0 / 1024.0;
                title = [NSString stringWithFormat:@"%.1fMB", floatSize];
            }else if(size > 1024){
                CGFloat floatSize = size / 1024.0;
                title = [NSString stringWithFormat:@"%.1fKB", floatSize];
            }else if(size > 0){
                title = [NSString stringWithFormat:@"%.1ldB", size];
            }else{
                title = @"0";
            }
            item.subTitle = title;
            cell.item = item;
        }
        
//        if (indexPath.row == 2){
//            BYArrowItem *item = [BYArrowItem itemWithImage:[UIImage imageNamed:@"new_friend"] title:@"关于"];
//            cell.item = item;
//        }
        
        if (indexPath.row == 1){
            BYArrowItem *item = [BYArrowItem itemWithImage:[UIImage imageNamed:@"fankui_24pt"] title:@"反馈"];
            cell.item = item;
            cell.spaceView.hidden = YES;
        }
        return cell;
    }
    
    else if (indexPath.section == 3){
        BYSettingCell *cell = [BYSettingCell cellWithTableView:tableView];
        BYLabelItem *item = [[BYLabelItem alloc] init];
        item.text = @"退出登录";
        cell.item = item;
        cell.spaceView.hidden = NO;
        return cell;
    }
    
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"meControllerCell"];
        cell.textLabel.text = @"待开发";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }
    return 44;
}

//选中某一行时执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0){
        BYMeDetailController *meDetailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MeDetail"];
        meDetailVc.meInfo = self.meInfoFrame.meInfo;
        [self.navigationController pushViewController:meDetailVc animated:YES];
    }
    
    if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //进入收件箱
            BYMailController *mailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Mail"];
            mailVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mailVc animated:YES];
        }
        
        if (indexPath.row == 1) {
            //进入消息提醒
            BYMessageController *msgVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Message"];
            msgVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:msgVc animated:YES];
        }
        
        if (indexPath.row == 2) {
            //进入我收录的文章
            BYCollectionController *colVc = [[BYCollectionController alloc] init];
            //push控制器时隐藏tabbar
            colVc.hidesBottomBarWhenPushed = YES;
            colVc.title = @"我收录的文章";
            [self.navigationController pushViewController:colVc animated:YES];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //清空缓存
            [self cleanDisk];
        }
        else if (indexPath.row == 1){
            //反馈
//            BYLog(@"反馈");
            BYSendMailController *sendMailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sendMail"];
            sendMailVc.param.BYid = @"chujunhe1234";
            sendMailVc.param.content = @"\n\n\n\n\n\n发自我的iPhone";
            [self.navigationController pushViewController:sendMailVc animated:YES];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            //退出登录
            [self loginOut];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return kBottomBarHeight;
    }else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma marl 退出登录
- (void)loginOut{
    self.actionSheetType = 2;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否退出登录?退出将回到登录界面." delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil, nil];
    
    [sheet showInView:self.view];
}


#pragma mark 清空缓存
- (void)cleanDisk{
    self.actionSheetType = 1;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否清除缓存?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除" otherButtonTitles:nil, nil];
    
    [sheet showInView:self.view];
}

#pragma mark sheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.actionSheetType == 1) {
        //点击了清空就清楚缓存
        if (buttonIndex == 0) {
            [[SDImageCache sharedImageCache] clearDisk];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    else if (self.actionSheetType == 2){
        //退出登录
        if (buttonIndex == 0) {
            //清空程序保存的消息数
            self.lastMailCount = 0;
            self.lastReplyMeCount = 0;
            self.lastAtMeCount = 0;
            //注销用户
            [BYAccountTool setAccountNil];
            //回到登录界面
            BYOAuthController *oauthVc = [[BYOAuthController alloc] init];
            
            //设置窗口的根控制器
            [self.navigationController presentViewController:oauthVc animated:YES completion:nil];
//            [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil];
        }
    }
}


#pragma mark cell代理
- (void)cellSwitchValuedDidChanged:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:BYIsAutoPushNewMsgCountKey];
}
@end
