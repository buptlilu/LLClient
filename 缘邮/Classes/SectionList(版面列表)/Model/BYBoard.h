//
//  BYBoard.h
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYFavorite.h"
@interface BYBoard : BYFavorite
//下面这些属性注释掉了,因为从BYFavorite继承了
///**
// *  版面名称
// */
//@property(nonatomic, copy) NSString *name;
///**
// *  版主列表，以空格分隔各个id
// */
//@property(nonatomic, copy) NSString *manager;
///**
// *  版面描述
// */
//@property(nonatomic, copy) NSString *BYdescription;
///**
// *  版面所属类别
// */
//@property(nonatomic, copy) NSString *BYclass;
///**
// *  版面所属分区号
// */
//@property(nonatomic, copy) NSString *section;
///**
// *  今日主题总数(收藏夹接口)
// */
//@property(nonatomic, assign) int threads_today_count;


/**
 *  今日发文总数
 */
@property(nonatomic, assign) int post_today_count;
/**
 *  版面主题总数
 */
@property(nonatomic, assign) int post_threads_count;
/**
 *  版面文章总数
 */
@property(nonatomic, assign) int post_all_count;
/**
 *  版面当前在线用户数
 */
@property(nonatomic, assign) int user_online_count;
/**
 *  版面历史最大在线用户数
 */
@property(nonatomic, assign) int user_online_max_count;
/**
 *  版面历史最大在线用户数发生时间
 */
@property(nonatomic, assign) int user_online_max_time;
/**
 *  版面是否只读
 */
@property(nonatomic, assign) BOOL is_read_only;
/**
 *  版面是否不可回复
 */
@property(nonatomic, assign) BOOL is_no_reply;
/**
 *  版面书否允许附件
 */
@property(nonatomic, assign) BOOL allow_attachment;
/**
 *  版面是否允许匿名发文
 */
@property(nonatomic, assign) BOOL allow_anonymous;
/**
 *  版面是否允许转信
 */
@property(nonatomic, assign) BOOL allow_outgo;
/**
 *  当前登陆用户是否有发文/回复权限
 */
@property(nonatomic, assign) BOOL allow_post;
@end
/*name 	string 	版面名称
 manager 	string 	版主列表，以空格分隔各个id
 description 	string 	版面描述
 class 	string 	版面所属类别
 section 	string 	版面所属分区号
 post_today_count 	int 	今日发文总数
 threads_today_count 	int 	今日主题总数(收藏夹接口)
 post_threads_count 	int 	版面主题总数
 post_all_count 	int 	版面文章总数
 is_read_only 	boolean 	版面是否只读
 is_no_reply 	boolean 	版面是否不可回复
 allow_attachment 	boolean 	版面书否允许附件
 allow_anonymous 	boolean 	版面是否允许匿名发文
 allow_outgo 	boolean 	版面是否允许转信
 allow_post 	boolean 	当前登陆用户是否有发文/回复权限
 user_online_count 	int 	版面当前在线用户数
 user_online_max_count 	int 	版面历史最大在线用户数
 user_online_max_time 	int 	版面历史最大在线用户数发生时间
 
 description = 算法与程序设计竞赛;
	manager = wangzitian0 herb;
	section = 2;
	threads_today_count = 1;
	post_threads_count = 71663;
	allow_attachment = 1;
	allow_anonymous = 0;
	post_today_count = 11;
	allow_outgo = 0;
	is_no_reply = 0;
	allow_post = 1;
	post_all_count = 71663;
	is_read_only = 0;
	class = [学术];
	name = ACM_ICPC;
	user_online_count = 59;
 */
