//
//  BYLikeParam.h
//  缘邮
//
//  Created by LiLu on 16/5/22.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYBaseParam.h"

@interface BYLikeParam : BYBaseParam
/**
 *  true	string	合法的版面名称
 */
@property(nonatomic, copy) NSString *name;
/**
 *  id	true	int	文章或主题id
 */
@property(nonatomic, assign) int id;
/**
 up
 */
@property(nonatomic, copy) NSString *up;
@end
