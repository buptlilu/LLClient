//
//  BYMessageResult.h
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@class BYPagination;
@interface BYMessageResult : NSObject<MJKeyValue>

@property (nonatomic, copy) NSString *BYdescription;

@property(nonatomic, strong) BYPagination *pagination;

@property(nonatomic, strong) NSMutableArray *article;

@end
