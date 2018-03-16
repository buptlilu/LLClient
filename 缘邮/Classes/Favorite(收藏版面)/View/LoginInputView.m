//
//  LoginInputView.m
//  sw-reader
//
//  Created by mac on 17/3/29.
//  Copyright © 2017年 YouDao. All rights reserved.
//

#import "LoginInputView.h"

@implementation LoginInputView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, Main_Screen_Width, 60);
        self.normalPicker = DKColorWithRGBA(0x000000, 0x000000, 0.1, 0.1);
        
        //边框
        CGFloat spaceViewX = Main_Screen_Width * 0.08;
        CGFloat spaceViewY = self.height - 0.5;
        CGFloat spaceViewW = Main_Screen_Width - spaceViewX * 2;
        CGFloat spaceViewH = 0.5;
        UIView *spaceView = [UIView new];
        spaceView.dk_backgroundColorPicker = self.normalPicker;
        [self addSubview:spaceView];
        spaceView.frame = CGRectMake(spaceViewX, spaceViewY, spaceViewW, spaceViewH);
        self.spaceView = spaceView;
        
        //添加输入框
        CGFloat inputViewX = spaceViewX + 8;
        CGFloat inputViewW = Main_Screen_Width - 2 * inputViewX;
        CGFloat inputViewH = 20;
        CGFloat inputViewY = self.height - 16 - inputViewH;
        UITextField *inputView = [UITextField new];
        inputView.textAlignment = NSTextAlignmentLeft;
        inputView.font = [UIFont systemFontOfSize:16];
        inputView.dk_textColorPicker = DKColor_TEXTCOLOR_TITLE;
        inputView.dk_backgroundColorPicker = DKColor_BACKGROUND;
        inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:inputView];
        inputView.frame = CGRectMake(inputViewX, inputViewY, inputViewW, inputViewH);
        self.inputView = inputView;
    }
    return self;
}
@end
