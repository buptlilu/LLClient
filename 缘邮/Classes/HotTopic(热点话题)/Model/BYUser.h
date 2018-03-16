//
//  BYUser.h
//  缘邮
//
//  Created by LiLu on 15/12/1.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYUser : NSObject
/**
 *  用户id
 */
@property(nonatomic, copy) NSString *BYid;
/**
 *  用户发文数量
 */
@property(nonatomic, assign) int post_count;
/**
 *  用户上次登录时间，unixtimestamp
 */
@property(nonatomic, assign) long long int last_login_time;
/**
 *  用户上次登录
 */
@property(nonatomic, copy) NSString *last_login_ip;
/**
 *  用户是否隐藏性别和星座
 */
@property(nonatomic, assign) BOOL is_hide;
/**
 *  用户生命值
 */
@property(nonatomic, assign) int life;
/**
 *  用户是否通过注册审批
 */
@property(nonatomic, assign) BOOL is_register;
/**
 *  积分
 */
@property(nonatomic, assign) int score;
/**
 *  用户头像地址
 */
@property(nonatomic, copy) NSString *face_url;
/**
 *  用户是否在线
 */
@property(nonatomic, assign) BOOL is_online;
/**
 *  用户身份
 */
@property(nonatomic, copy) NSString *level;
/**
 *  用户昵称
 */
@property(nonatomic, copy) NSString *user_name;
/**
 *  用户msn
 */
@property(nonatomic, copy) NSString *msn;
/**
 *  用户星座 若隐藏星座则为空
 */
@property(nonatomic, copy) NSString *astro;
/**
 *  用户头像宽度
 */
@property(nonatomic, assign) int face_width;
/**
 *  用户头像高度
 */
@property(nonatomic, assign) int face_height;
/**
 *  用户qq
 */
@property(nonatomic, copy) NSString *qq;
/**
 *  用户性别：m表示男性，f表示女性，n表示隐藏性别
 */
@property(nonatomic, copy) NSString *gender;
/**
 *  用户个人主页
 */
@property(nonatomic, copy) NSString *home_page;

@end
/*
 user = {
	id = YIMO86;
	post_count = 447;
	last_login_time = 1448946157;
	last_login_ip = 10.203.23.*;
	is_hide = 0;
	life = 365;
	is_register = 1;
	score = 4441;
	face_url = http://static.byr.cn/uploadFace/Y/YIMO86.4446.jpg;
	is_online = 1;
	level = 用户;
	user_name = 【意涵团】肉肉甩甩甩不掉;
	msn = ;
	astro = 未知;
	face_height = 120;
	qq = ;
	face_width = 120;
	gender = f;
	home_page = ;
 }

 */
