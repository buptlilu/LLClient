//
//  BYArticleLikeResult.h
//  缘邮
//
//  Created by lilu on 2017/6/6.
//  Copyright © 2017年 chujunhe1234. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYArticleLikeResult : NSObject
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) int like_sum;
@property (nonatomic, copy) NSString *request;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@end
/*
 点赞成功： {"status":true,"like_sum":"26"}
 点赞失败：{
	"request": "/article/Talking/like/5917696.json",
	"code": "1603",
	"msg": "已赞过，不能更赞"
 }
 */
