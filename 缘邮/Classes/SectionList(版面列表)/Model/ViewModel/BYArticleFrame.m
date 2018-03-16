//
//  BYArticleFrame.m
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYArticleFrame.h"
#import "BYArticle.h"
#import "BYTextTool.h"
#import "AppDelegate.h"

#import "YYText.h"

@implementation BYArticleFrame


-(void)setArticle:(BYArticle *)article{
    _article = article;
    
    //计算用户信息frame
    [self calculateUserViewFrame];
}


-(void)calculateUserViewFrame{
    //头像
    CGFloat iamgeX = BYBoardArticleMargin;
    CGFloat imageY = BYBoardArticleMargin;
    CGFloat imageWH = 35;
    _userIconFrame = CGRectMake(iamgeX, imageY, imageWH, imageWH);
    
    //用户名
    CGFloat nameX = CGRectGetMaxX(_userIconFrame) + BYBoardArticleMargin;
    CGFloat nameY = BYBoardArticleMargin;
    NSMutableDictionary *nameAttr = [NSMutableDictionary dictionary];
    nameAttr[NSFontAttributeName] = BYBoardArticleUserNameFont;
    CGSize nameSize = [_article.user.user_name sizeWithAttributes:nameAttr];
    CGFloat nameW = BYScreenW - 3 * BYBoardArticleMargin - imageWH - 30;
    _userNameFrame = CGRectMake(nameX, nameY, nameW, nameSize.height);
    
    //用户楼层
    NSMutableDictionary *posSumAttr = [NSMutableDictionary dictionary];
    posSumAttr[NSFontAttributeName] = BYArticlePositionFont;
    CGSize posSize = [@"1000楼" sizeWithAttributes:posSumAttr];
    CGFloat likeX = BYScreenW - BYBoardArticleMargin - posSize.width;
    CGFloat likeY = CGRectGetMaxY(_userIconFrame) - posSize.height;
    _userPositionFrame = CGRectMake(likeX, likeY, posSize.width, posSize.height);
    
    //评论正文
    CGFloat contentX = BYBoardArticleMargin;
    CGFloat contentY = BYBoardArticleMargin + CGRectGetMaxY(_userIconFrame);
    CGFloat contentW = BYScreenW - 2 * BYBoardArticleMargin;
    
    //正文
    UIColor *titleColor = [XUtil isDay] ? [XUtil hexToRGB:@"333333"] : [XUtil hexToRGB:@"585d61"];
    NSMutableAttributedString *content = [BYTextTool textWithStr:_article fontSize:16 textColor:titleColor];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:delegate.imgViewsForArticleCell];
    _imgViews = arrM;
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(contentW, MAXFLOAT);
//    [content yy_appendString:@"\n"];
    _textLayout = [YYTextLayout layoutWithContainer:container text:content];
//    BYLog(@"%@", content.string);
//    NSMutableDictionary *contentAttr = [NSMutableDictionary dictionary];
//    contentAttr[NSFontAttributeName] = BYArticleContentFont;
    CGSize contentSize = _textLayout.textBoundingSize;
//    BYLog(@"%f===%f===%f", contentSize.width, contentW, contentSize.height);
    _articleContentFrame = CGRectMake(contentX, contentY, contentW, contentSize.height + 3 * BYBoardArticleMargin);
    
    //用户view
    CGFloat userX = 0;
    CGFloat userY = 0;
    CGFloat userW = BYScreenW;
    CGFloat userH = CGRectGetMaxY(_articleContentFrame) + BYBoardArticleMargin * 3;
    _userViewFrame = CGRectMake(userX, userY, userW, userH);
    
    //cell高度
    _cellHeight = CGRectGetMaxY(_userViewFrame);
    _spaceViewFrame = CGRectMake(BYBoardArticleMargin, _cellHeight - 0.5, Main_Screen_Width, 0.5);
}
@end
