//
//  BYCollection.h
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYUser;
@interface BYCollection : NSObject
/**
 *  作者
 */
@property (nonatomic, strong) BYUser *user;

/**
 *  主题名称
 */
@property (nonatomic, copy) NSString *title;

/**
 *  发帖时间
 */
@property (nonatomic, copy) NSString *postTime;

/**
 *  所属版面
 */
@property (nonatomic, copy) NSString *bname;

/**
 *  回复数量
 */
@property (nonatomic, copy) NSString *num;

/**
 *  主题ID
 */
@property (nonatomic, assign) int gid;

/**
 *  添加时间
 */
@property (nonatomic, copy) NSString *createdTime;

@end


/*
 user = <null>;
	title = [指定的文章不存在或链接错误] 原贴标题: [问题]测试;
	createdTime = 1456120123;
	postTime = 0;
	num = 0;
	gid = 26347;
	bname = Communications;
 */
