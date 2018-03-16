//
//  BYTabBar.h
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYTabBar;

@protocol BYTabBarDelegate <NSObject>

@optional
-(void)tabBar:(BYTabBar *)tabBar didClickButton:(NSInteger) index;
@end

@interface BYTabBar : UIView

/**
 *  items：保存每一个按钮对应的tabBarItem模型
 */
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, weak) id<BYTabBarDelegate> delegate;
@end
