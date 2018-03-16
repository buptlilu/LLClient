//
//  BYFile.h
//  缘邮
//
//  Created by LiLu on 15/12/1.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYFile : NSObject
/**
 *  文件名
 */
@property(nonatomic, copy) NSString *name;
/**
 *  文件链接，在用户空间的文件，该值为空
 */
@property(nonatomic, copy) NSString *url;
/**
 *  文件大小
 */
@property(nonatomic, copy) NSString *size;
/**
 *  小缩略图链接(宽度120px)，用户空间的文件，该值为空	附件为图片格式(jpg,png,gif)
 */
@property(nonatomic, copy) NSString *thumbnail_small;
/**
 *  中缩略图链接(宽度240px)，用户空间的文件，该值为空	附件为图片格式(jpg,png,gif)
 */
@property(nonatomic, copy) NSString *thumbnail_middle;
@end
/*
 file = (
	{
	size = 248.6KB;
	thumbnail_small = http://bbs.byr.cn/api/attachment/Friends/1704712/821/small;
	thumbnail_middle = http://bbs.byr.cn/api/attachment/Friends/1704712/821/middle;
	name = IMG_0166.JPG;
	url = http://bbs.byr.cn/api/attachment/Friends/1704712/821;
 }

 */
