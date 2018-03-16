//
//  BYArticle.h
//  缘邮
//
//  Created by LiLu on 15/12/1.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

/*
 文章/主题元数据
 属性	类型	说明	存在条件
 id	int	文章id
 group_id	int	该文章所属主题的id
 reply_id	int	该文章回复文章的id
 flag	string	文章标记 分别是m g ; b u o 8
 position	int	文章所在主题的位置或文章在默写浏览模式下的位置	/board/:name的非主题模式下为访问此文章的id，在/threads/:board/:id中为所在主题中的位置，其余为空
 is_top	boolean	文章是否置顶
 is_subject	boolean	该文章是否是主题帖
 has_attachment	boolean	文章是否有附件
 is_admin	boolean	当前登陆用户是否对文章有管理权限 包括编辑，删除，修改附件
 title	string	文章标题
 user	user	文章发表用户，这是一个用户元数据
 post_time	int	文章发表时间，unixtimestamp
 board_name	string	所属版面名称
 content	string	文章内容	在/board/:name的文章列表和/search/(article|threads)中不存在此属性
 attachment	attachment	文章附件列表，这是一个附件元数据	在/board/:name的文章列表和/search/(article|threads)中不存在此属性
 previous_id	int	该文章的前一篇文章id	只存在于/article/:board/:id中
 next_id	int	该文章的后一篇文章id	只存在于/article/:board/:id中
 threads_previous_id	int	该文章同主题前一篇文章id	只存在于/article/:board/:id中
 threads_next_id	int	该文章同主题后一篇文章id	只存在于/article/:board/:id中
 reply_count	int	该主题回复文章数	只存在于/board/:name，/threads/:board/:id和/search/threads中
 last_reply_user_id	string	该文章最后回复者的id	只存在于/board/:name，/threads/:board/:id和/search/threads中
 last_reply_time	int	该文章最后回复的时间 unxitmestamp	只存在于/board/:name，/threads/:board/:id和/search/threads中
 */
#import <Foundation/Foundation.h>
#import "BYUser.h"
#import "BYAttachment.h"
#import "BYFile.h"

#import "MJExtension.h"

@interface BYArticle : NSObject

/**
 *  文章id
 */
@property(nonatomic, assign) int BYid;

/**
 *  该主题回复文章数	只存在于/board/:name，/threads/:board/:id和/search/threads中
 */
@property(nonatomic, assign) int reply_count;

/**
 *  该主题回复文章数	只存在于/board/:name，/threads/:board/:id和/search/threads中
 */
@property(nonatomic, copy) NSString *replyCountText;

/**
 *  文章所在主题的位置或文章在默写浏览模式下的位置	/board/:name的非主题模式下为访问此文章的id，在/threads/:board/:id中为所在主题中的位置，其余为空
 */
@property(nonatomic, assign) int position;
/**
 *  该文章是否是主题帖
 */
@property(nonatomic, assign) BOOL is_subject;
/**
 *  该文章回复文章的id
 */
@property(nonatomic, assign) long int reply_id;
/**
 *  文章是否置顶
 */
@property(nonatomic, assign) BOOL is_top;
/**
 *  所属版面名称
 */
@property(nonatomic, copy) NSString *board_name;
/**
 * 该文章最后回复者的id
 */
@property(nonatomic, copy) NSString *last_reply_user_id;
/**
 *  文章是否有附件
 */
@property(nonatomic, assign) BOOL has_attachment;
/**
 *  文章标题
 */
@property(nonatomic, copy) NSString *title;
/**
 *  该文章最后回复的时间 unxitmestamp	只存在于/board/:name，/threads/:board/:id和/search/threads中
 */
@property(nonatomic, copy) NSString *last_reply_time_text;
@property(nonatomic, assign) NSString *last_reply_time;
/**
 *  文章标记 分别是m g ; b u o 8
 */
@property(nonatomic, copy) NSString *flag;
/**
 *  该文章所属主题的id
 */
@property(nonatomic, assign) int group_id;
/**
 *  文章附件列表，这是一个附件元数据	在/board/:name的文章列表和/search/(article|threads)中不存在此属性
 */
@property(nonatomic, strong) BYAttachment *attachment;
/**
 *  十大数量
 */
@property(nonatomic, assign) int id_count;
/**
 *  当前登陆用户是否对文章有管理权限 包括编辑，删除，修改附件
 */
@property(nonatomic, assign) BOOL is_admin;
/**
 *  文章发表用户，这是一个用户元数据
 */
@property(nonatomic, strong) BYUser *user;
/**
 *  文章发表时间，unixtimestamp
 */
@property(nonatomic, copy) NSString *post_time_text;
@property(nonatomic, copy) NSString *post_time;
/**
 *  文章内容	在/board/:name的文章列表和/search/(article|threads)中不存在此属性
 */
@property(nonatomic, copy) NSString *content;

/**
 *  赞的个数
 */
@property(nonatomic, copy) NSString *like_sum_text;
@property(nonatomic, assign) int like_sum;

/**
 *  是否是精彩评论
 */
@property(nonatomic, assign) BOOL is_liked;
@end

/*
 
 {
	id = 2844519;
	reply_count = 33;
	position = 0;
	is_subject = 1;
	reply_id = 2844519;
	is_top = 0;
	board_name = Feeling;
	last_reply_user_id = lishaokai;
	has_attachment = 0;
	title = 男朋友一晚上关机(24);
	last_reply_time = 1448928476;
	flag = ;
	group_id = 2844519;
	attachment = {
	remain_count = 20;
	file = (
 );
	remain_space = 5MB;
 }
 ;
	id_count = 24;
	is_admin = 0;
	user = {
	id = YIMO86;
	post_count = 444;
	last_login_time = 1448926372;
	last_login_ip = 10.203.23.*;
	is_hide = 0;
	life = 365;
	is_register = 1;
	score = 4441;
	face_url = http://static.byr.cn/uploadFace/Y/YIMO86.4446.jpg;
	is_online = 0;
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
 ;
	post_time = 1448899946;
	content = 。。自从傍晚六点多给我打了一个电话后，持续关机状态到现在…虽然觉得应该没什么事，但是还是无法控制地特别不开心。。。。
 好烦啊，好烦啊。。。。
 
 发自「贵邮」
 -;
 }
 
 */
