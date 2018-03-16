//
//  BYSection.h
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "name": "0",
 "description": "本站站务",
 "is_root": true,
 "parent": null
 
 name	string	分区名称
 description	string	分区表述
 is_root	boolean	是否是根分区
 parent	string	该分区所属根分区名称
 */

@interface BYSection : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *is_root;
@property(nonatomic, copy) NSString *parent;

@end
