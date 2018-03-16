//
//  BYUserMusic.m
//  缘邮
//
//  Created by LiLu on 16/3/1.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYUserMusic.h"

#define kMusicIndex    @"MusicIndex"
#define kMusicLocation @"MusicLocation"

@implementation BYUserMusic

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.index forKey:kMusicIndex];
    [aCoder encodeInteger:self.location forKey:kMusicLocation];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.index = [aDecoder decodeIntegerForKey:kMusicIndex];
        self.location = [aDecoder decodeIntegerForKey:kMusicLocation];
    }
    return self;
}

@end
