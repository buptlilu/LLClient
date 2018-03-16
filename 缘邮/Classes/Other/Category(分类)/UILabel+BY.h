//
//  UILabel+BY.h
//  缘邮
//
//  Created by lilu on 2017/6/7.
//  Copyright © 2017年 chujunhe1234. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKColor.h"

@interface UILabel (BY)
+ (instancetype)labelWith:(UIFont *)font textColor:(DKColorPicker)picker textAlignment:(NSTextAlignment)textAlignment;
@end
