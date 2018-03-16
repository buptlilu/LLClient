//
//  BYSettingCell.h
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYBaseCell.h"

@protocol BYSettingCellDelegate <NSObject>

@optional
- (void)cellSwitchValuedDidChanged:(UISwitch *)sender;

@end

@class BYSettingItem;
@interface BYSettingCell : BYBaseCell
@property (nonatomic, strong) UIView *spaceView;
@property(nonatomic, strong) BYSettingItem *item;

@property (nonatomic, weak) id<BYSettingCellDelegate> delegate;
@end
