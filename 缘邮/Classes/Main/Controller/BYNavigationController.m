//
//  BYNavigationController.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYNavigationController.h"
#import "UIBarButtonItem+Item.h"

@interface BYNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong) id popDelegate;

@end

@implementation BYNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
//        self.fullScreenPopGestureEnabled = YES;
    }
    return self;
}


+(void)initialize{
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    
    self.delegate = self;
    
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self.viewControllers[0]) { //显示根控制器
        //还原滑动返回手势的代理
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
    }else{//不是根控制器
        //实现滑动返回功能
        //清空滑动返回手势的功能，就能实现滑动功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}
#pragma mark - UIGestureRecognizerDelegate
//这个方法在视图控制器完成push的时候调用
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}
//导航控制器即将显示新的控制器的适时候调用
//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    //获取主窗口
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    
//    //获取tabBarVc
//    UITabBarController *tabBarVc = (UITabBarController *)keyWindow.rootViewController;
//    
//    for (UIView *tabBarButton in tabBarVc.tabBar.subviews) {
//        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [tabBarButton removeFromSuperview];
//        }
//    }
//}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //设置非根控制器导航条的内容
    if (self.viewControllers.count != 0) {//非根控制器
        //设置导航条的内容
        //设置导航条左边和右边
        //如果把导航条上的返回按钮覆盖了，滑动返回功能就没有了
        //左边
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backToPre)];
        viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
    
    [super pushViewController:viewController animated:YES];
}

-(void)backToPre{
    [self popViewControllerAnimated:YES];
}

-(void)backToRoot{
    [self popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
