//
//  BYCollectionListResult.m
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYCollectionListResult.h"
#import "BYCollection.h"
#import "MJExtension.h"

@interface BYCollectionListResult () <MJKeyValue>

@end

@implementation BYCollectionListResult

+(NSDictionary *)objectClassInArray{
    return @{@"article" : [BYCollection class]};
}

@end
