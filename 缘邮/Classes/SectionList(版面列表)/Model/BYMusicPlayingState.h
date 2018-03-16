//
//  BYMusicPlayingState.h
//  缘邮
//
//  Created by LiLu on 16/3/1.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYMusicPlayingState, AudioStreamer, douPlayer;
@interface BYMusicPlayingState : NSObject

@property (nonatomic, strong) douPlayer * player;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *currentTimeText;
@property (nonatomic, copy) NSString *totalTimeText;
@property (nonatomic, assign) double currentTime;
@property (nonatomic, assign) double totalTime;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isPlaying;


+ (BYMusicPlayingState *)shareMusicPlayingState;

@end
