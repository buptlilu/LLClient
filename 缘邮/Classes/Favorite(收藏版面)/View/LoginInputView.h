//
//  LoginInputView.h
//  sw-reader
//
//  Created by mac on 17/3/29.
//  Copyright © 2017年 YouDao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginInputView : UIView
@property (nonatomic, copy) DKColorPicker normalPicker;
@property (nonatomic, weak) UITextField *inputView;
@property (nonatomic, weak) UIView *spaceView;
@end
