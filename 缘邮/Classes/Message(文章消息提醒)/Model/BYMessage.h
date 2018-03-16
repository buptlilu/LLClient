//
//  BYMessage.h
//  缘邮
//
//  Created by LiLu on 16/2/22.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYUser;
@interface BYMessage : NSObject

/**
 *  提醒文章的发信人，此为user元数据，如果user不存在则为用户id
 */
@property (nonatomic, strong) BYUser *user;
/**
 *  提醒是否已读
 */
@property (nonatomic, assign) BOOL is_read;
/**
 *  提醒文章的group id
 */
@property (nonatomic, assign) int group_id;
/**
 *  提醒文章的id
 */
@property (nonatomic, assign) int BYid;

/**
 *  提醒文章所在版面
 */
@property (nonatomic, copy) NSString *board_name;

/**
 *  提醒文章的reply id
 */
@property (nonatomic, assign) int reply_id;

/**
 *  提醒文章的标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  发出提醒的时间
 */
@property (nonatomic, copy) NSString *time;

/**
 *  作者回复自己时,帖子所在的位置
 */
@property (nonatomic, assign) int pos;

/**
 *  提醒编号，此编号用于提醒的相关操作
 */
@property (nonatomic, assign) int index;

/**
 *  只能为at|reply中的一个，分别是@我的文章和回复我的文章
 */
@property (nonatomic, copy) NSString *type;
@end

/*
 {
	user = {
	id = changzhu;
	post_count = 6322;
	last_login_time = 1456126526;
	last_login_ip = 117.136.79.*;
	is_hide = 0;
	life = 666;
	is_register = 1;
	score = 2130;
	face_url = http://static.byr.cn/uploadFace/C/changzhu.8148.jpg;
	is_online = 1;
	level = 用户;
	user_name = 猪哥梁;
	msn = ;
	astro = 金牛座;
	face_height = 91;
	qq = 357982047;
	face_width = 120;
	gender = m;
	home_page = ;
 }
 ;
	is_read = 1;
	group_id = 4658;
	id = 4737;
	board_name = dotNET;
	reply_id = 4658;
	title = Re: [问题]C# MouseMove移动时鼠标的坐标问题;
	time = 1454212788;
	pos = 1;
	index = 214;
 }
 
 */
