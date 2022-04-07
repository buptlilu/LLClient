//
//  YDNavigationController.m
//  sw-reader
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "YDNavigationController.h"
#import "UIViewController+JTNavigationExtension.h"

@interface YDNavigationController ()
@end

@implementation YDNavigationController

+ (void)initialize{
    //获取当前类下面的UIBarButtonItem
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    //设置导航条按钮的文字颜色
    NSMutableDictionary *titleAtt = [NSMutableDictionary dictionary];
    titleAtt[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:titleAtt forState:UIControlStateNormal];
    
    NSMutableDictionary *titleAttDisabled = [NSMutableDictionary dictionary];
    titleAttDisabled[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:titleAttDisabled forState:UIControlStateDisabled];
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    bar.barStyle = UIBarStyleBlack;
    [bar setBarTintColor:[UIColor lightGrayColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.currentShowVC = rootViewController;
        self.fullScreenPopGestureEnabled = YES;
    }
    return self;
}
@end
