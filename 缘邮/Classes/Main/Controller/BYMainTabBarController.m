//
//  BYMainTabBarController.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYMainTabBarController.h"
#import "BYHotTopicController.h"
#import "BYMeController.h"
#import "BYSectionController.h"
#import "BYNavigationController.h"
#import "BYFavoriteController.h"
#import "BYTabBar.h"
#import "BYMailTool.h"
#import "BYMailParam.h"
#import "BYMailResult.h"
#import "BYMail.h"

@interface BYMainTabBarController ()<BYTabBarDelegate>

@property(nonatomic, strong) NSMutableArray *tabBarButtonItems;

@property(nonatomic, weak) BYSectionController *section;
@property(nonatomic, weak) BYHotTopicController *hot;
@property(nonatomic, weak) BYFavoriteController *favorite;
@property(nonatomic, weak) BYMeController *me;

@end

@implementation BYMainTabBarController


-(NSMutableArray *)tabBarButtonItems{
    if (!_tabBarButtonItems) {
        _tabBarButtonItems = [NSMutableArray array];
    }
    return _tabBarButtonItems;
}

+(void)initialize{
    //获取所有tabBarItem外观表示
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    attr[NSFontAttributeName] =
    attr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [item setTitleTextAttributes:attr forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控制器
    [self setUpAllChildViewController];
    
    //自定义tabBar
    [self setUpTabBar];
    
    //每隔一段时间请求未读数
    [self.me loadNewCount];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(requestUnread) userInfo:nil repeats:YES];
}

//#pragma mark 请求未读信息
//-(void)requestUnread{
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:BYIsAutoPushNewMsgCountKey]) {
//        [self.me loadNewCountAndNote];
//    }
//}

#pragma mark  -自定义tabBar
-(void)setUpTabBar{
    BYTabBar *tabBar = [[BYTabBar alloc] initWithFrame:self.tabBar.bounds];
//    BYLog(@"tabbar高度:%f 宽度:%f", self.tabBar.bounds.size.height, self.tabBar.bounds.size.width);
//    CZTabBar *tabBar = [[CZTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.delegate = self;
    tabBar.items = self.tabBarButtonItems;
    [self.tabBar addSubview:tabBar];
}

-(void)setUpAllChildViewController{
    //添加子控制器
    BYSectionController *section = [[BYSectionController alloc] init];
    [self setUpOneChildViewController:section image:[UIImage imageWithOriginalName:@"articleiPhoneSpootlight7_40pt"]selectedImage:[UIImage imageWithOriginalName:@"articleHighiPhoneSpootlight7_40pt"] title:@"版面"];
    self.section = section;
    
    BYHotTopicController *hot = [[BYHotTopicController alloc] init];
    [self setUpOneChildViewController:hot image:[UIImage imageWithOriginalName:@"sectioniPhoneSpootlight7_40pt"] selectedImage:[UIImage imageWithOriginalName:@"sectionHighiPhoneSpootlight7_40pt"] title:@"热点"];
    self.hot = hot;
    
    BYFavoriteController *favorite = [[BYFavoriteController alloc] init];
     [self setUpOneChildViewController:favorite image:[UIImage imageWithOriginalName:@"stariPhoneSpootlight7_40pt"] selectedImage:[UIImage imageWithOriginalName:@"starHighiPhoneSpootlight7_40pt"] title:@"收藏"];
    self.favorite = favorite;
    
    BYMeController *me = [[BYMeController alloc] init];
    [self setUpOneChildViewController:me image:[UIImage imageWithOriginalName:@"meiPhoneSpootlight7_40pt"] selectedImage:[UIImage imageWithOriginalName:@"meHighiPhoneSpootlight7_40pt"] title:@"我的"];
    self.me = me;
}

-(void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title{
    
    //    vc.tabBarItem.title = title;
    
    vc.title = title;
    
    vc.tabBarItem.image = image;
//    vc.tabBarItem.badgeValue = @"10";
    vc.tabBarItem.selectedImage = selectedImage;
    
    [self.tabBarButtonItems addObject:vc.tabBarItem];
    
    BYNavigationController *nav = [[BYNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //移除系统自带的tabBarButton
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton removeFromSuperview];
        }
    }
}

-(void)tabBar:(BYTabBar *)tabBar didClickButton:(NSInteger)index{
    self.selectedIndex = index;
}
@end
