//
//  BYBoardArticleFrame.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoardArticleFrame.h"
#import "BYArticle.h"

@implementation BYBoardArticleFrame

-(void)setArticle:(BYArticle *)article{
    _article = article;
    
    //计算frame
    [self calculateFrame];
    
    //计算cell高度
    _cellHeight = CGRectGetMaxY(_userNameLabelFrame) + BYBoardArticleMargin;
    _spaceViewFrame = CGRectMake(BYBoardArticleMargin, _cellHeight - 0.5, Main_Screen_Width, 0.5);
}

-(void)calculateFrame{
    //头像
    CGFloat imageX = BYBoardArticleMargin;
    CGFloat imageY = BYBoardArticleMargin;
    CGFloat imageWH = 35;
    _userIconViewFrame = CGRectMake(imageX, imageY, imageWH, imageWH);
    
    //标题
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = BYBoardArticleTitleFont;
    CGFloat titleX = CGRectGetMaxX(_userIconViewFrame) + BYBoardArticleMargin;
    CGFloat titleY = imageY;
    CGFloat titleW = BYScreenW - CGRectGetMaxX(_userIconViewFrame) - 2 * BYBoardArticleMargin;
    _article.title = [NSString stringWithFormat:@"%@%@", _article.has_attachment ? @"🔗" : @"", _article.title];
    CGSize titleSize = [_article.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttr context:nil].size;
    _titleLabelFrame = CGRectMake(titleX, titleY, titleW, titleSize.height);
    
    //回复
    NSMutableDictionary *replyCountAttr = [NSMutableDictionary dictionary];
    replyCountAttr[NSFontAttributeName] = BYBoardArticleReplyCountFont;
    CGSize replyCountSize = [@"99999回复" sizeWithAttributes:replyCountAttr];
    CGFloat replyCountX = BYScreenW - BYBoardArticleMargin - replyCountSize.width;
    CGFloat replyCountY = CGRectGetMaxY(_titleLabelFrame) + BYBoardArticleMargin;
    _replyCountLabelFrame = CGRectMake(replyCountX, replyCountY, replyCountSize.width, replyCountSize.height);
    
    //时间
    NSMutableDictionary *timeAttr = [NSMutableDictionary dictionary];
    timeAttr[NSFontAttributeName] = BYBoardArticleTimeFont;
    CGSize timeSize = [@"02-23 15:3000" sizeWithAttributes:timeAttr];
    CGFloat timeX = _replyCountLabelFrame.origin.x - timeSize.width;
    CGFloat timeY = CGRectGetMaxY(_titleLabelFrame) + BYBoardArticleMargin;
    _timeLabelFrame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    //名字
    CGFloat nameX = CGRectGetMaxX(_userIconViewFrame) + BYBoardArticleMargin;
    CGFloat nameY = CGRectGetMaxY(_titleLabelFrame) + BYBoardArticleMargin;
    CGFloat nameW = BYScreenW - (BYScreenW - timeX) - CGRectGetMaxX(_userIconViewFrame) - 2 *BYBoardArticleMargin;
    NSMutableDictionary *nameAttr = [NSMutableDictionary dictionary];
    nameAttr[NSFontAttributeName] = BYBoardArticleUserNameFont;
    NSString *userName = _article.user.BYid;
    if (!userName) {
        userName = @"原帖已删除";
    }
    CGSize nameSize = [userName boundingRectWithSize:CGSizeMake(nameW, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:nameAttr context:nil].size;
    _userNameLabelFrame = CGRectMake(nameX, nameY, nameW, nameSize.height);
}

@end
