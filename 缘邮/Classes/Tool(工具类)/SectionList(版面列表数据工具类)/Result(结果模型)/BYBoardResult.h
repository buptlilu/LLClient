//
//  BYBoardResult.h
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "MJExtension.h"

@interface BYBoardResult : NSObject <MJKeyValue>

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *BYdescription;
@property(nonatomic, assign) BOOL is_root;
@property(nonatomic, copy) NSString *parent;
@property(nonatomic, strong) NSMutableArray *sub_section;
@property(nonatomic, strong) NSMutableArray *board;

@end
