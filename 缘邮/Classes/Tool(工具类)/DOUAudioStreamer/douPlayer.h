//
//  douPlayer.h
//  DeerGuide
//
//  Created by kan xu on 15/8/24.
//  Copyright (c) 2015年 kan xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioFile.h"
#import "DOUAudioStreamer.h"

@interface Track : NSObject <DOUAudioFile>
//这里可以
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *audioFileURL;

@end

@interface douPlayer : NSObject

@property (nonatomic, strong) Track *track;

@property (nonatomic) float currentTime;

//状态相关
- (BOOL)isWorking;
- (BOOL)isPlaying;
- (BOOL)isTruePlaying;

//播放相关
- (void)play;
- (void)pause;
- (void)stop;

//定时器开放的接口
- (void)startTimer;
- (void)stopTimer;

- (void)shake;

@property(nonatomic,copy) void(^statusBlock)(DOUAudioStreamer *streamer);
@property(nonatomic,copy) void(^durationBlock)(DOUAudioStreamer *streamer);
@property(nonatomic,copy) void(^bufferingRatioBlock)(DOUAudioStreamer *streamer);

@end
