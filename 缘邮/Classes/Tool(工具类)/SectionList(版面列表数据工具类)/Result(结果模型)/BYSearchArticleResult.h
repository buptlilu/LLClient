//
//  BYSearchArticleResult.h
//  缘邮
//
//  Created by LiLu on 16/3/2.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYPagination;
@interface BYSearchArticleResult : NSObject

@property(nonatomic, strong) BYPagination *pagination;

@property(nonatomic, strong) NSMutableArray *threads;

@end
