//
//  BYMeDetailController.m
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMeDetailController.h"
#import "BYMeResult.h"
#import "BYUser.h"
#import "BYSendMailController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "UIImageView+WebCache.h"
#import "NSDate+MJ.h"
#import "YYImage.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface BYMeDetailController () <UIActionSheetDelegate>
//头像
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

//性别
@property (weak, nonatomic) IBOutlet UILabel *userSexLabel;

//论坛ID
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;

//星座
@property (weak, nonatomic) IBOutlet UILabel *userAstroLabel;

//QQ
@property (weak, nonatomic) IBOutlet UILabel *userQQLabel;

//MSN
@property (weak, nonatomic) IBOutlet UILabel *userMSNLabel;


//主页
@property (weak, nonatomic) IBOutlet UILabel *userHomePageLabel;

//论坛等级
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;

//帖子总数
@property (weak, nonatomic) IBOutlet UILabel *userPostCountLabel;

//积分
@property (weak, nonatomic) IBOutlet UILabel *userScoreLabel;

//生命力
@property (weak, nonatomic) IBOutlet UILabel *userLifeLabel;

//上次登录
@property (weak, nonatomic) IBOutlet UILabel *userLastLoginTimeLabel;

//最后访问IP
@property (weak, nonatomic) IBOutlet UILabel *userLastLoginIPLabel;

//当前状态
@property (weak, nonatomic) IBOutlet UILabel *userCurrentStateLabel;


@end

@implementation BYMeDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题和右边写信按钮
    [self setUpNavigationItem];
    
    //设置各个具体值
    [self setUpData];
}

- (void)setUpNavigationItem{
    self.navigationItem.leftBarButtonItem.dk_tintColorPicker = DKColor_BACKGROUND_NAVBAR_TINT;
    self.navigationItem.title = @"个人信息";
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeMail)];
    bar.dk_tintColorPicker = DKColor_BACKGROUND_NAVBAR_TINT;
    self.navigationItem.rightBarButtonItem = bar;
}

- (void)writeMail{
//    BYLog(@"写邮件");
    BYSendMailController *sendMailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sendMail"];
    sendMailVc.sendUserId = self.meInfo.BYid;
    [self.navigationController pushViewController:sendMailVc animated:YES];
}

- (void)setUpData{
    if (self.meInfo == nil) {
        return;
    }
    
    //头像
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.meInfo.face_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //昵称
    NSRange rangeStart = [_meInfo.user_name rangeOfString:@"("];
    NSRange rangeEnd = [_meInfo.user_name rangeOfString:@")"];
    NSRange rangeCapture = NSMakeRange(rangeStart.location + 1, rangeEnd.location - rangeStart.location -1 );
    self.userNameLabel.text = [_meInfo.user_name substringWithRange:rangeCapture];
//    self.userNameLabel.text = self.meInfo.user_name;
    
    //性别
    if ([self.meInfo.gender isEqualToString:@"m"]) {
        self.userSexLabel.text = @"男生";
    }else if ([self.meInfo.gender isEqualToString:@"f"]){
        self.userSexLabel.text = @"女生";
    }else if([self.meInfo.gender isEqualToString:@"n"]){
        self.userSexLabel.text = @"保密";
    }else{
        self.userSexLabel.text = @"保密";
    }
    
    //论坛ID
    self.userIdLabel.text = self.meInfo.BYid;
    
    //星座
    self.userAstroLabel.text = self.meInfo.astro;
    
    //QQ
    self.userQQLabel.text = self.meInfo.qq;
    
    //MSN
    self.userMSNLabel.text = self.meInfo.msn;
    
    //主页
    self.userHomePageLabel.text = self.meInfo.home_page;
    
    //论坛等级
    self.userLevelLabel.text = self.meInfo.level;
    
    //帖子总数
    self.userPostCountLabel.text = [NSString stringWithFormat:@"%d篇", self.meInfo.post_count];
    
    //积分
    self.userScoreLabel.text = [NSString stringWithFormat:@"%d", self.meInfo.score];
    
    //生命力
    self.userLifeLabel.text = [NSString stringWithFormat:@"%d", self.meInfo.life];
    
    //上次登录
    //获取到文章的时间
    NSDate *postTime = [NSDate dateWithTimeIntervalSince1970:self.meInfo.last_login_time];
    
    self.userLastLoginTimeLabel.text = [postTime stringFromBYDate];
    
    //最后访问IP
    self.userLastLoginIPLabel.text = self.meInfo.last_login_ip;
    
    //当前状态
    if (self.meInfo.is_online == 1) {
        self.userCurrentStateLabel.text = @"在线";
    } else {
        self.userCurrentStateLabel.text = @"离线";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 80;
    }else{
        return 44;
    }
}

//保存头像到本地相册
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存头像", nil];
        
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    BYLog(@"%ld", (long)buttonIndex);
    
    if (buttonIndex == 0) {
        //保存图片到本地
//        BYLog(@"%@", self.userIcon.sd_imageURL);
        NSData *data = [NSData dataWithContentsOfURL:self.userIcon.sd_imageURL];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//            BYLog(@"Success at %@", [assetURL path]);
            if (error) {
                [MBProgressHUD showError:@"保存失败,用户未授权"];
            } else {
                [MBProgressHUD showSuccess:@"保存成功"];
            }
        }];
    }
}

/*
 {
	home_page = ;
	face_width = 0;
	astro = 狮子座;
	last_login_time = 1455624853;
	is_hide = 0;
	life = 365;
	login_count = 5057;
	is_online = 1;
	is_register = 1;
	score = 8446;
	first_login_time = 1365758180;
	msn = ;
	id = lilu;
	gender = m;
	level = 用户;
	is_admin = 0;
	face_height = 0;
	post_count = 269;
	role = 在校生用户;
	stay_count = 5751722;
	face_url = http://static.byr.cn/img/face_default_m.jpg;
	qq = 98956@qq.com];
	last_login_ip = 111.204.176.148;
	user_name = 雪影;
 }

 */

@end
