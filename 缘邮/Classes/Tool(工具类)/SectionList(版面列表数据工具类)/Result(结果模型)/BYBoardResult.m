//
//  BYBoardResult.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoardResult.h"
#import "BYBoard.h"

@implementation BYBoardResult
@synthesize description;
+(NSDictionary *)objectClassInArray{
    return @{@"board" : [BYBoard class]};
}

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"BYdescription":@"description"};
}
@end
