//
//  BYGroupitem.h
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYGroupItem : NSObject

/**
 *  一组有多少行(CZSettingItem)
 */
@property(nonatomic, strong) NSArray *items;
/**
 *  头部标题
 */
@property(nonatomic, copy) NSString *headerTitle;
/**
 *  尾部标题
 */
@property(nonatomic, copy) NSString *footerTitle;

@end
