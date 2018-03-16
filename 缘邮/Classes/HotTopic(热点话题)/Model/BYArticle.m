//
//  BYArticle.m
//  缘邮
//
//  Created by LiLu on 15/12/1.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYArticle.h"
#import "NSDate+MJ.h"

@implementation BYArticle

-(void)setReply_count:(int)reply_count{
    _reply_count = reply_count;
    _replyCountText = [NSString stringWithFormat:@"%d回复", _reply_count - 1];
}

-(NSString *)like_sum_text{
    return [NSString stringWithFormat:@"%d赞", _like_sum];
}

-(NSString *)post_time_text{
    //获取到文章的时间
    NSDate *postTime = [NSDate dateWithTimeIntervalSince1970:[_post_time longLongValue]];
    return [postTime stringFromBYDate];
}

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"BYid" : @"id"};
}
@end
