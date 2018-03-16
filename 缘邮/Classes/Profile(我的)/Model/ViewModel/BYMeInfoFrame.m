//
//  BYMeInfoFrame.m
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMeInfoFrame.h"

#import "BYMeResult.h"


#define IconMargin 10

@implementation BYMeInfoFrame

- (void)setMeInfo:(BYMeResult *)meInfo{
    _meInfo = meInfo;
    
    NSRange rangeStart = [_meInfo.user_name rangeOfString:@"("];
    NSRange rangeEnd = [_meInfo.user_name rangeOfString:@")"];
    NSRange rangeCapture = NSMakeRange(rangeStart.location + 1, rangeEnd.location - rangeStart.location -1 );
    _userName = [_meInfo.user_name substringWithRange:rangeCapture];
    
    _userId = [NSString stringWithFormat:@"论坛ID:%@", _meInfo.BYid];
    
    NSLog(@"%@====%@", _userName, _userId);
    
    //计算frame
//    [self calculateFrame];
    
    //计算cell高度
//    _cellHeight = CGRectGetMaxY(_userIconViewFrame) + IconMargin;
}

- (void)calculateFrame{
    //头像
    CGFloat iconWH = 50;
    _userIconViewFrame = CGRectMake(IconMargin, IconMargin, iconWH, iconWH);
    
    //昵称
    //用户名
    CGFloat nameX = CGRectGetMaxX(_userIconViewFrame) + IconMargin;
    CGFloat nameY = 0;
    NSMutableDictionary *nameAttr = [NSMutableDictionary dictionary];
    nameAttr[NSFontAttributeName] = BYMeInfoUserNameFont;
    CGSize nameSize = [_userName sizeWithAttributes:nameAttr];
    nameY = (2 * IconMargin + _userIconViewFrame.size.height ) * 0.5 - IconMargin * 0.5 - nameSize.height;
    _userNameLabelFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    //id
    CGFloat idX = CGRectGetMaxX(_userIconViewFrame) + IconMargin;
    CGFloat idY = CGRectGetMaxY(_userNameLabelFrame) + IconMargin;
    NSMutableDictionary *idAttr = [NSMutableDictionary dictionary];
    idAttr[NSFontAttributeName] = BYMeInfoUserIdFont;
    CGSize idSize = [_userId sizeWithAttributes:idAttr];
    _userIdLabelFrame = CGRectMake(idX, idY, idSize.width, idSize.height);
}

@end
