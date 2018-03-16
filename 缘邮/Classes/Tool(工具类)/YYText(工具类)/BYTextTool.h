//
//  BYTextTool.h
//  缘邮
//
//  Created by LiLu on 16/2/19.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYArticle, YYTextSimpleEmoticonParser, BYTextParser;

@interface BYTextTool : NSObject

/**
 *  返回正则处理完毕的文章正文
 *
 *  @param testStr   处理前的正文字符串
 *  @param fontSize  正文字体
 *  @param textColor 正文颜色
 *
 *  @return 正则处理完毕的正文
 */
+ (NSMutableAttributedString *)textWithStr:(BYArticle *)article
                                  fontSize:(CGFloat)fontSize
                                 textColor:(UIColor *)textColor;

/**
 *  设置em表情识别器
 *
 *  @return 识别器
 */
+ (YYTextSimpleEmoticonParser *)setUpParser;

/**
 *  正则匹配@
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexAt;

/**
 *  正则匹配附件
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexAttachment;

/**
 *  正则匹配网址
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexHttp;

/**
 *  正则匹配发自哪个客户端
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexSource;

/**
 *  正则匹配大表情
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexBigEmoticon;

/**
 *  正则匹配小表情
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexSmallEmoticon;

@end
