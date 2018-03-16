//
//  AppDelegate.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "AppDelegate.h"
#import "BYMainTabBarController.h"
#import "BYRootTool.h"
#import "BYOAuthController.h"
#import "BYAccountTool.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import <UMMobClick/MobClick.h>

@interface AppDelegate ()

@property(nonatomic,strong) AVAudioPlayer *player;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //选择根控制器
    //判断下有没有授权
    if ([BYAccountTool account]) { //已经授权
        //选择根控制器
        [BYRootTool chooseRootViewController:self.window];
    }else{ //进行授权
        //进行授权
        BYOAuthController *oauthVc = [[BYOAuthController alloc] init];
        
        //设置窗口的根控制器
        self.window.rootViewController = oauthVc;
    }
    
    [self.window makeKeyAndVisible];
    
    //如果iOS版本大于8，要请求用户授权是否允许发送本地通知
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
    
    [UMSocialData setAppKey:@"56d2dd7767e58e9cfb001350"];
    
    //友盟统计信息
    [UMAnalyticsConfig sharedInstance].appKey = @"56d2dd7767e58e9cfb001350";
    [MobClick startWithConfigure:[UMAnalyticsConfig sharedInstance]];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxad7021f08c501f09" appSecret:@"659a56585e128d5ae784a42849056b15" url:nil];//@"http://bbs.byr.cn/#"];
    
    return YES;
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    //使用SDWebImage要做下面这俩事情
    //停止所有下载
    [[SDWebImageManager sharedManager] cancelAll];
    
    //删除缓存
    [[SDWebImageManager sharedManager].imageCache clearDisk];
}

//让程序在后台也能接收到通知
//- (void)applicationWillResignActive:(UIApplication *)application {
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"silence.mp3" withExtension:nil];
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    [player prepareToPlay];
//    player.numberOfLoops = -1;
//    [player play];
//    _player = player;
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    //开启一个后台任务,时间不确定，优先级比较低，假如系统要关闭应用，首先就考虑这个
//    UIBackgroundTaskIdentifier ID = [application beginBackgroundTaskWithExpirationHandler:^{
//        //当后台任务结束的时候调用
//        [application endBackgroundTask:ID];
//    }];
//    
//    //如何提高后台任务的优先级，欺骗苹果，我们是后台播放程序
//    //但是苹果会检测你的程序当时有没有播放音乐，如果没有，有可能就干掉你
//    //新浪微博是这样做的：在程序即将失去焦点的时候播放静音音乐，0KB。
//}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
