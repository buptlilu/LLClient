//
//  BYMusicPlayingState.m
//  缘邮
//
//  Created by LiLu on 16/3/1.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYMusicPlayingState.h"

@implementation BYMusicPlayingState

+ (BYMusicPlayingState *)shareMusicPlayingState{
    static BYMusicPlayingState *state = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        state = [[self alloc] init];
    });
    return state;
}

@end
