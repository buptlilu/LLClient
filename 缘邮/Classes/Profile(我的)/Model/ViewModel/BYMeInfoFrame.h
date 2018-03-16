//
//  BYMeInfoFrame.h
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYMeResult;
@interface BYMeInfoFrame : NSObject

@property (nonatomic, strong) BYMeResult *meInfo;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) CGRect userIconViewFrame;

@property (nonatomic, assign) CGRect userNameLabelFrame;

@property (nonatomic, assign) CGRect userIdLabelFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@end
