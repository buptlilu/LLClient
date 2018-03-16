//
//  ViewController.m
//  sw-reader
//
//  Created by 白静 on 4/4/16.
//  Copyright © 2016 卢坤. All rights reserved.
//

#import "DKViewController.h"
#import "DKNightVersion.h"

static dispatch_queue_t bs_operation_processing_queue;
static dispatch_queue_t operation_processing_queue() {
    if (bs_operation_processing_queue == NULL) {
        bs_operation_processing_queue = dispatch_queue_create("operation.bisheng.youdao.com", 0);
    }
    return bs_operation_processing_queue;
}

@interface DKViewController ()

@end

@implementation DKViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem.dk_tintColorPicker = DKColor_BACKGROUND_NAVBAR_TINT;
    }
//    self.navigationController.navigationBar.dk_barTintColorPicker = DKColor_BACKGROUND_NAVBAR;
    //self.navigationController.navigationBar.dk_tintColorPicker = DKColor_BACKGROUND_NAVBAR;
    //self.navigationController.navigationBar.dk_backgroundColorPicker = DKColor_BACKGROUND_NAVBAR;
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.dk_backgroundColorPicker = DKColor_BACKGROUND;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.queue.operations.count) {
        [self.queue cancelAllOperations];
    }
}

#pragma mark - functions
- (NSOperationQueue *)queue {
    static NSOperationQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
    });
    _queue = queue;
    return _queue;
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)addOperation:(BSBasicBlock)operation beginBlock:(BSBasicBlock)begin finishBlock:(BSBasicBlock)finish {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (begin) {
            begin();
        }
        dispatch_async(operation_processing_queue(), ^{
            if (operation) {
                operation();
            }
            dispatch_async(dispatch_get_main_queue(),^{
                if (finish) {
                    finish();
                }
            });
        });
    });
}

- (void)setUpNavBarLeftView {
    CGSize barSize = CGSizeMake(24,24);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width * 82 /640, kTopBarHeight)];
    UIImageView *leftPicView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kTopBarHeight - barSize.height - 9, barSize.width, barSize.height)];
    leftPicView.dk_imagePicker = DKImageWithNames(@"index_ic_BackArrow_day", @"index_ic_BackArrow_day_night");
    [leftView addSubview:leftPicView];
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backIndex)];
    [leftView addGestureRecognizer:leftTap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navBarLeftView = leftView;
}

- (void)setUpNavBarTitleView:(NSString *)title {
    self.navigationItem.title = title;
    return;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = NavBarTitleFont;
    [titleLabel setTextColor:[XUtil hexToRGB:@"333333"]];
    titleLabel.dk_textColorPicker = DKColorWithRGB(0xFFFFFF, 0x8f969b);
    NSString *titleStr = [NSString stringWithFormat:@" %@ ", title];
    CGSize titleStrSize = [XUtil sizeWithString:titleStr font:NavBarTitleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    titleLabel.frame = CGRectMake(0,50, titleStrSize.width,titleStrSize.height);
    titleLabel.text = titleStr;
    self.navigationItem.titleView = titleLabel;
    self.navBarTitleView = titleLabel;
}

- (void)setUpNavBarRightView:(DKImagePicker)imagePicker;{
    CGSize barSize = CGSizeMake(24, 24);
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTopBarHeight, kTopBarHeight)];
    UIImageView *rightPicView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kTopBarHeight - barSize.height - 9, barSize.width, barSize.height)];
    rightPicView.dk_imagePicker = imagePicker;
    [rightView addSubview:rightPicView];
    [rightPicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(barSize);
        make.centerY.mas_equalTo(rightView.mas_centerY);
        make.right.equalTo(rightView);
    }];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navBarRightViewTap)];
    [rightView addGestureRecognizer:rightTap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navBarRightView = rightView;
}

- (void)navBarRightViewTap {
    
}

- (void)backIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
