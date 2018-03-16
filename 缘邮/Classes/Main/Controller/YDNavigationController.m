//
//  YDNavigationController.m
//  缘邮
//
//  Created by lilu on 2017/6/7.
//  Copyright © 2017年 chujunhe1234. All rights reserved.
//

#import "YDNavigationController.h"

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
        BYLog(@"vctype:%@", NSStringFromClass([rootViewController class]));
        self.fullScreenPopGestureEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
@end
