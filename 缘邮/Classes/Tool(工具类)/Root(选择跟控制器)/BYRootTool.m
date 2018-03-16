//
//  BYRootTool.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYRootTool.h"
#import "BYMainTabBarController.h"
#import "BYNewFeatureController.h"
#import "DKViewController.h"
#import "RDVTabBarController.h"
#import "YDNavigationController.h"
#import "RDVTabBarItem.h"
#import "BYSectionController.h"
#import "BYHotTopicController.h"
#import "BYFavoriteController.h"
#import "BYMeController.h"

#define BYVersionKey @"version"

@implementation BYRootTool

//选择根控制器
+ (void)chooseRootViewController:(UIWindow *)window{
    //1.获取当前的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    //2.获取上一次的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:BYVersionKey];
    
    if ([currentVersion isEqualToString:lastVersion]) { //没有最新的版本号
//        BYMainTabBarController *vc = [[BYMainTabBarController alloc] init];
//        window.rootViewController = vc;
//        return;
        
        BYSectionController *firstViewController = [[BYSectionController alloc] init];
        YDNavigationController *firstNavigationController = [[YDNavigationController alloc] initWithRootViewController:firstViewController];
        firstNavigationController.currentShowVC = firstViewController;
        
        //    WMPageController *secondViewController = [BookViewUtil getPageController];
        //    BookMainViewController *secondViewController = [[BookMainViewController alloc] init];
        BYHotTopicController *secondViewController = [[BYHotTopicController alloc] init];
        YDNavigationController *secondNavigationController = [[YDNavigationController alloc] initWithRootViewController:secondViewController];
        
        BYFavoriteController *thirdViewController = [[BYFavoriteController alloc] init];
        YDNavigationController *thirdNavigationController = [[YDNavigationController alloc] initWithRootViewController:thirdViewController];
        
        
        BYMeController *fourthViewController = [[BYMeController alloc] init];
        YDNavigationController *fourthNavigationController = [[YDNavigationController alloc] initWithRootViewController:fourthViewController];
        
        RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
        tabBarController.tabBar.dk_backgroundColorPicker = DKColor_BACKGROUND_TABBAR;
        [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController, thirdNavigationController, fourthNavigationController]];
        [self customizeTabBarForController:tabBarController];
        tabBarController.selectedIndex = 1;
        window.rootViewController = tabBarController;
        
    }else{//有最新的版本号
        //进入新特性界面
        
        //v1.0
        //判断当前是否有新的版本
        //如果有新特性，就进入新特性界面
        BYNewFeatureController *newFeatureVc = [[BYNewFeatureController alloc] init];
        window.rootViewController = newFeatureVc;
        
        //保存当前的版本，用偏好设置
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:BYVersionKey];
    }
}

+ (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    NSArray *tabBarItemImagesNormal = @[@"articleiPhoneSpootlight7_40pt", @"sectioniPhoneSpootlight7_40pt", @"stariPhoneSpootlight7_40pt", @"meiPhoneSpootlight7_40pt"];
    NSArray *tabBarItemImagesHighLighted = @[@"articleHighiPhoneSpootlight7_40pt", @"sectionHighiPhoneSpootlight7_40pt", @"starHighiPhoneSpootlight7_40pt", @"meHighiPhoneSpootlight7_40pt"];
    NSArray *tabBarItemTitles = @[@"版面", @"热点", @"收藏", @"我的"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        
        UIImage *unselectedimage = [UIImage imageNamed:tabBarItemImagesNormal[index]];
        UIImage *selectedimage = [UIImage imageNamed:tabBarItemImagesHighLighted[index]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:tabBarItemTitles[index]];
        item.dk_backgroundColorPicker = DKColor_BACKGROUND_TABBAR;
        index++;
    }
}
@end
