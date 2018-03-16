//
//  BYTextTool.m
//  缘邮
//
//  Created by LiLu on 16/2/19.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYTextTool.h"
#import "BYArticle.h"
#import "BYUser.h"
#import "BYAttachment.h"
#import "BYBaseParam.h"
#import "BYPlayerToolBar.h"
#import "BYSongTimeView.h"
#import "BYSongPlayView.h"
#import "BYUserMusic.h"
#import "BYIsAttaAdded.h"
#import "AppDelegate.h"

#import "UIImageView+WebCache.h"
#import "YYText.h"
#import "YYImage.h"
#import "UIImage+YYWebImage.h"
#import "UIView+YYAdd.h"
#import "NSBundle+YYAdd.h"
#import "NSString+YYAdd.h"
#import "YYTextExampleHelper.h"
#import "YYGestureRecognizer.h"
#import "NSAttributedString+YYText.h"
#import "MWPhotoBrowser.h"
#import "UIImage+CZ.h"

@implementation BYTextTool

+ (YYTextSimpleEmoticonParser *)setUpParser{
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    NSMutableDictionary *mapper = [NSMutableDictionary new];
    
    //添加表情对应的图片
    NSString *emName = @"";
    NSString *emImage = @"";
    for (int i = 1; i <= 73; i++) {
        emName = [NSString stringWithFormat:@"[em%d]", i];
        emImage = [NSString stringWithFormat:@"%@.gif", emName];
        mapper[emName] = [YYImage imageNamed:emImage];
    }
    
    for (int i = 0; i <= 41; i++) {
        emName = [NSString stringWithFormat:@"[ema%d]", i];
        emImage = [NSString stringWithFormat:@"%@.gif", emName];
        mapper[emName] = [YYImage imageNamed:emImage];
    }
    
    for (int i = 0; i <= 24; i++) {
        emName = [NSString stringWithFormat:@"[emb%d]", i];
        emImage = [NSString stringWithFormat:@"%@.gif", emName];
        mapper[emName] = [YYImage imageNamed:emImage];
    }
    
    for (int i = 0; i <= 58; i++) {
        emName = [NSString stringWithFormat:@"[emc%d]", i];
        emImage = [NSString stringWithFormat:@"%@.gif", emName];
        mapper[emName] = [YYImage imageNamed:emImage];
    }
    
    parser.emoticonMapper = mapper;
    return parser;
    
}


+ (NSMutableAttributedString *)textWithStr:(BYArticle *)article
                                  fontSize:(CGFloat)fontSize
                                 textColor:(UIColor *)textColor {
    if (!article) return nil;
    
    NSMutableString *string = article.content.mutableCopy;
    if (string.length == 0) return nil;
    
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor lightGrayColor];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = [UIFont systemFontOfSize:fontSize];
    text.yy_color = textColor;
    text.yy_lineSpacing = 5;
    
    //创建一个数组,来保存当前是否已经匹配完成了所有的附件
    NSMutableArray *fileBoolArray;
    if (article.attachment.file.count) {
        fileBoolArray = [NSMutableArray array];
        for (NSInteger i = 0; i < article.attachment.file.count; i++) {
            BYIsAttaAdded *isAdded = [[BYIsAttaAdded alloc] init];
            isAdded.isAdded = NO;
            [fileBoolArray addObject:isAdded];
        }
    }
    
    // 匹配B加粗字体
    {
        NSArray *sourceResults = [[self regexB] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        //偏移
        NSUInteger sourceClipLength = 0;
        for (NSTextCheckingResult *source in sourceResults) {
            NSRange sourceRange = source.range;
            sourceRange.location -= sourceClipLength;
            
            if (sourceRange.location == NSNotFound && sourceRange.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:sourceRange.location] == nil) {
                NSAttributedString *sourceStr = [text attributedSubstringFromRange:sourceRange];
                NSRange rangeTextBegin = [sourceStr.string rangeOfString:@"[b]"];
                NSRange rangeTextEnd = [sourceStr.string rangeOfString:@"[/b]"];
                NSAttributedString *textSource = [sourceStr attributedSubstringFromRange:NSMakeRange(rangeTextBegin.location + rangeTextBegin.length, rangeTextEnd.location - rangeTextBegin.location - rangeTextBegin.length)];
                [text replaceCharactersInRange:sourceRange withAttributedString:textSource];
                [text yy_setFont:[UIFont boldSystemFontOfSize:[sourceStr.yy_font pointSize]] range:NSMakeRange(sourceRange.location, textSource.length)];
                sourceClipLength += sourceStr.length - textSource.length;
            }
        }
    }
    
    // 匹配I斜体字体
    {
        NSArray *sourceResults = [[self regexI] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        //偏移
        NSUInteger sourceClipLength = 0;
        for (NSTextCheckingResult *source in sourceResults) {
            NSRange sourceRange = source.range;
            sourceRange.location -= sourceClipLength;
            
            if (sourceRange.location == NSNotFound && sourceRange.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:sourceRange.location] == nil) {
                NSAttributedString *sourceStr = [text attributedSubstringFromRange:sourceRange];
                NSRange rangeTextBegin = [sourceStr.string rangeOfString:@"[i]"];
                NSRange rangeTextEnd = [sourceStr.string rangeOfString:@"[/i]"];
                NSAttributedString *textSource = [sourceStr attributedSubstringFromRange:NSMakeRange(rangeTextBegin.location + rangeTextBegin.length, rangeTextEnd.location - rangeTextBegin.location - rangeTextBegin.length)];
                [text replaceCharactersInRange:sourceRange withAttributedString:textSource];
                [text yy_setFont:YYTextFontWithItalic(textSource.yy_font) range:NSMakeRange(sourceRange.location, textSource.length)];
                sourceClipLength += sourceStr.length - textSource.length;
            }
        }
    }

    
    
    // 匹配U下划线字体
    {
        NSArray *sourceResults = [[self regexU] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        //偏移
        NSUInteger sourceClipLength = 0;
        for (NSTextCheckingResult *source in sourceResults) {
            NSRange sourceRange = source.range;
            sourceRange.location -= sourceClipLength;
            
            if (sourceRange.location == NSNotFound && sourceRange.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:sourceRange.location] == nil) {
                
                //设置高亮
                NSString *sourceStr = [text.string substringWithRange:sourceRange];
//                BYLog(@"%@", sourceStr);
                
                NSRange rangeTextBegin = [sourceStr rangeOfString:@"[u]"];
                NSRange rangeTextEnd = [sourceStr rangeOfString:@"[/u]"];
                NSString *textSource = [sourceStr substringWithRange:NSMakeRange(rangeTextBegin.location + rangeTextBegin.length, rangeTextEnd.location - rangeTextBegin.location - rangeTextBegin.length)];
//                BYLog(@"%@", textSource);
                NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:textSource];
                one.yy_font = [UIFont systemFontOfSize:fontSize];
                [one setYy_underlineStyle:NSUnderlineStyleSingle];
                [text replaceCharactersInRange:sourceRange withAttributedString:one];
                sourceClipLength += sourceStr.length - one.length;
            }
        }
    }
    
    // 匹配颜色字体
    {
        NSArray *sourceResults = [[self regexColor] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        //偏移
        NSUInteger sourceClipLength = 0;
        for (NSTextCheckingResult *source in sourceResults) {
            NSRange sourceRange = source.range;
            sourceRange.location -= sourceClipLength;
            
            if (sourceRange.location == NSNotFound && sourceRange.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:sourceRange.location] == nil) {
                NSAttributedString *sourceStr = [text attributedSubstringFromRange:sourceRange];
                NSRange rangeTextBegin = [sourceStr.string rangeOfString:@"[color=#"];
                NSRange rangeTextEnd = [sourceStr.string rangeOfString:@"[/color]"];
                NSString *color = [sourceStr.string substringWithRange:NSMakeRange(rangeTextBegin.location + 8, 6)];
                BYLog(@"rgb:%@", color);
                unsigned red, green, blue;
                [[NSScanner scannerWithString:[color substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red];
                [[NSScanner scannerWithString:[color substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
                [[NSScanner scannerWithString:[color substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue];
                NSAttributedString *textSource = [sourceStr attributedSubstringFromRange:NSMakeRange(rangeTextBegin.location + 15, rangeTextEnd.location - rangeTextBegin.location - 15)];
                [text replaceCharactersInRange:sourceRange withAttributedString:textSource];
                UIColor *myColor = [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1];
                [text yy_setColor:myColor range:NSMakeRange(sourceRange.location, textSource.length)];
                //设置高亮
                sourceClipLength += sourceStr.length - textSource.length;
            }
        }
    }
    
    // 匹配size字体
    {
        NSArray *sourceResults = [[self regexSize] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        //偏移
        NSUInteger sourceClipLength = 0;
        for (NSTextCheckingResult *source in sourceResults) {
            NSRange sourceRange = source.range;
            sourceRange.location -= sourceClipLength;
            
            if (sourceRange.location == NSNotFound && sourceRange.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:sourceRange.location] == nil) {
                NSAttributedString *sourceStr = [text attributedSubstringFromRange:sourceRange];
                NSRange rangeSizeBegin = [sourceStr.string rangeOfString:@"[size="];
                NSRange rangeTextBegin = [sourceStr.string rangeOfString:@"]"];
                NSRange rangeTextEnd = [sourceStr.string rangeOfString:@"[/size]"];
                NSString *size = [sourceStr.string substringWithRange:NSMakeRange(rangeSizeBegin.location + 6, rangeTextBegin.location - rangeSizeBegin.location - 1)];
                NSAttributedString *textSource = [sourceStr attributedSubstringFromRange:NSMakeRange(rangeTextBegin.location + 1, rangeTextEnd.location - rangeTextBegin.location - 1)];
                [text replaceCharactersInRange:sourceRange withAttributedString:textSource];
                [text yy_setFont:[UIFont systemFontOfSize:(fontSize + ([size floatValue] - 2.0) * 3.0)] range:NSMakeRange(sourceRange.location, textSource.length)];
                //设置高亮
                sourceClipLength += sourceStr.length - textSource.length;
            }
        }
    }

    
   
    
    // 匹配大表情
    {
        NSUInteger emoClipLength = 0;
        NSArray *emResults = [[self regexBigEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *em in emResults) {
            if (em.range.location == NSNotFound && em.range.length <= 1) continue;
            
            NSRange range = em.range;
            range.location -= emoClipLength;
            
            if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                //把表情换成表情图片
                NSString *emoStr = [text.string substringWithRange:range];
                
                YYImage *image = [YYImage imageNamed:[NSString stringWithFormat:@"%@.gif", emoStr]];
                
                if (image) {
                    //图片不为空,就替换成表情
                    NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:40];
                    [text replaceCharactersInRange:range withAttributedString:emoText];
                    emoClipLength += range.length - 1;
                }
            }
        }
    }
    
    // 匹配小表情
    {
        NSUInteger emoClipLength = 0;
        NSArray *emResults = [[self regexSmallEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *em in emResults) {
            if (em.range.location == NSNotFound && em.range.length <= 1) continue;
            
            NSRange range = em.range;
            range.location -= emoClipLength;
            
            if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                //把表情换成表情图片
                NSString *emoStr = [text.string substringWithRange:range];
                
                YYImage *image = [YYImage imageNamed:[NSString stringWithFormat:@"%@.gif", emoStr]];
                
                if (image) {
                    //图片不为空,就替换成表情
                    NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:40];
                    [text replaceCharactersInRange:range withAttributedString:emoText];
                    emoClipLength += range.length - 1;
                }
            }
        }
    }
    
    
 
    // 匹配 pdf附件
    {
        //如果有附件再匹配
        if (article.has_attachment) {
            NSArray *attaResults = [[self regexAttachment] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
            //偏移
            NSUInteger attaClipLength = 0;
            //取出附件里的文件
            NSArray *files = article.attachment.file;
            
            for (NSTextCheckingResult *atta in attaResults)
            {
                NSRange attaRange = atta.range;
                attaRange.location -= attaClipLength;
                if (attaRange.location == NSNotFound && attaRange.length <= 1) continue;
                
                if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:attaRange.location]) continue;
                if ([text yy_attribute:YYTextHighlightAttributeName atIndex:attaRange.location] == nil)
                {
                    
                    //设置高亮
                    YYTextHighlight *highlight = [YYTextHighlight new];
                    //                    BYLog(@"获取值前:%@===%@===", NSStringFromRange(attaRange), NSStringFromRange(atta.range));
                    NSInteger fileIndex = [[text.string substringWithRange:NSMakeRange(attaRange.location + 8, attaRange.length - 8 - 10)] integerValue];
                    
                    BYFile *file = nil;
                    if (fileIndex <= files.count && fileIndex > 0)
                    {
                        file = files[fileIndex - 1];
                        
                        //附件
                        BYBaseParam *param = [BYBaseParam param];
                        if ([file.name hasSuffix:@".pdf"] || [file.name hasSuffix:@".PDF"] ||
                            [file.name hasSuffix:@".exe"] || [file.name hasSuffix:@".EXE"] ||
                            [file.name hasSuffix:@".swf"] || [file.name hasSuffix:@".SWF"] ||
                            [file.name hasSuffix:@".zip"] || [file.name hasSuffix:@".ZIP"] ||
                            [file.name hasSuffix:@".rar"] || [file.name hasSuffix:@".RAR"] ||
                            [file.name hasSuffix:@".apk"] || [file.name hasSuffix:@".APK"] ||
                            [file.name hasSuffix:@".ppt"] || [file.name hasSuffix:@".PPT"] ||
                            [file.name hasSuffix:@".pptx"] || [file.name hasSuffix:@".PPTX"] ||
                            [file.name hasSuffix:@".word"] || [file.name hasSuffix:@".WORD"] ||
                            [file.name hasSuffix:@".7z"] || [file.name hasSuffix:@".7Z"] ||
                            [file.name hasSuffix:@"xlsx"] || [file.name hasSuffix:@".XLSX"] ||
                            [file.name hasSuffix:@".txt"] || [file.name hasSuffix:@".TXT"]){
                            //设置图片url
                            NSString *pdfUtrStr = [NSString stringWithFormat:@"%@?oauth_token=%@", file.url, param.oauth_token];
                            //设置高亮
                            [highlight setColor:[UIColor blueColor]];
                            [highlight setBackgroundBorder:highlightBorder];
                            NSString *pdfStr = [NSString stringWithFormat:@"附件(%@) %@", file.size, file.name];
                            highlight.userInfo = @{BYPDFUrlKey : pdfUtrStr};
                            NSRange newSourceRange = NSMakeRange(attaRange.location, pdfStr.length);
                            [text replaceCharactersInRange:attaRange withString:pdfStr];
                            [text yy_setTextHighlightRange:newSourceRange color:[UIColor blueColor] backgroundColor:nil tapAction:nil];
                            [text yy_setTextHighlight:highlight range:newSourceRange];
                            
                            //偏移量累计
                            attaClipLength += attaRange.length - pdfStr.length;
                            
                            //更新标记位
                            BYIsAttaAdded *isAttaAdded = [fileBoolArray objectAtIndex:fileIndex - 1];
                            isAttaAdded.isAdded = YES;
                            [fileBoolArray replaceObjectAtIndex:fileIndex - 1 withObject:isAttaAdded];
                        }
                    }
                }
            }
        }
    }

    
    // 匹配 图片附件
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.imgViewsForArticleCell = [NSMutableArray array];
    {
        //如果有附件再匹配
        if (article.has_attachment) {
            NSArray *attaResults = [[self regexAttachment] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
            //偏移
            NSUInteger attaClipLength = 0;
            //取出附件里的文件
            NSArray *files = article.attachment.file;
            
            for (NSTextCheckingResult *atta in attaResults)
            {
                NSRange attaRange = atta.range;
                attaRange.location -= attaClipLength;
                if (attaRange.location == NSNotFound && attaRange.length <= 1) continue;
                
                if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:attaRange.location]) continue;
                if ([text yy_attribute:YYTextHighlightAttributeName atIndex:attaRange.location] == nil)
                {
                    
                    //设置高亮
                    YYTextHighlight *highlight = [YYTextHighlight new];
//                    BYLog(@"获取值前:%@===%@===", NSStringFromRange(attaRange), NSStringFromRange(atta.range));
                    NSInteger fileIndex = [[text.string substringWithRange:NSMakeRange(attaRange.location + 8, attaRange.length - 8 - 10)] integerValue];
                    
                    BYFile *file = nil;
                    if (fileIndex <= files.count && fileIndex > 0)
                    {
                        file = files[fileIndex - 1];
                        
                        //附件
                        NSMutableAttributedString *atta = nil;
                        BYBaseParam *param = [BYBaseParam param];
                        if ([file.name hasSuffix:@".jpg"] || [file.name hasSuffix:@".png"] ||
                                  [file.name hasSuffix:@".bmp"] || [file.name hasSuffix:@".gif"] ||
                                  [file.name hasSuffix:@".JPG"] || [file.name hasSuffix:@".PNG"] ||
                                  [file.name hasSuffix:@".BMP"] || [file.name hasSuffix:@".GIF"] ||
                                  [file.name hasSuffix:@".jpeg"] || [file.name hasSuffix:@".JPEG"]){
                            NSString *attachmentIndex = [text.string substringWithRange:NSMakeRange(attaRange.location + 8, attaRange.length - 8 - 10)];
                            highlight.userInfo = @{BYAttachmentImageNumberKey : attachmentIndex};
                            
                            //创建imageView
                            CGFloat imgWH = BYScreenW - 2 * BYBoardArticleMargin;
                            CGFloat imgX = (BYScreenW - imgWH - BYBoardArticleMargin) * 0.5;
                            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, 0, imgWH, imgWH)];
                            CALayer *layer = [imgView layer];
                            layer.borderColor = [[UIColor whiteColor] CGColor];
                            layer.borderWidth = 20;
                            
                            //设置图片url
                            NSString *imgUtrStr = [NSString stringWithFormat:@"%@?oauth_token=%@", file.url, param.oauth_token];
                            //设置imgView图片大小自适应
                            imgView.contentMode = UIViewContentModeScaleAspectFit;
                            //设置图片
                            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUtrStr] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
                            [delegate.imgViewsForArticleCell addObject:imgView];
                            
//                            BYLog(@"===imgUtrStr%@", imgUtrStr);
                            //转换成附件
                            atta = [NSMutableAttributedString yy_attachmentStringWithContent:imgView contentMode:UIViewContentModeCenter attachmentSize:imgView.size alignToFont:[UIFont systemFontOfSize:fontSize] alignment:YYTextVerticalAlignmentCenter];
                            [text replaceCharactersInRange:attaRange withAttributedString:atta];
                            //把偏移量-1
                            attaClipLength += attaRange.length - 1;
                            //图片和表情一样,长度均为1
                            
                            [text yy_setTextHighlight:highlight range:NSMakeRange(attaRange.location, 1)];
                            
                            BYIsAttaAdded *isAttaAdded = [fileBoolArray objectAtIndex:fileIndex - 1];
                            isAttaAdded.isAdded = YES;
                            [fileBoolArray replaceObjectAtIndex:fileIndex - 1 withObject:isAttaAdded];
                        }
                    }
                }
            }
        }
    }
    
    
    
    // 匹配 发自某个客户端
    {
        NSArray *sourceResults = [[self regexSource] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        //偏移
        NSUInteger sourceClipLength = 0;
        for (NSTextCheckingResult *source in sourceResults) {
            NSRange sourceRange = source.range;
            sourceRange.location -= sourceClipLength;
            
            if (sourceRange.location == NSNotFound && sourceRange.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:sourceRange.location] == nil) {
                
                //设置高亮
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setColor:[UIColor blueColor]];
                [highlight setBackgroundBorder:highlightBorder];
                
                NSString *wholeStr = [text.string substringWithRange:NSMakeRange(sourceRange.location, sourceRange.length)];
                NSString *urlStr = [self getUrlFromSourceWholeStr:wholeStr];
                NSRange rangeBegin = [wholeStr rangeOfString:@"]"];
                NSRange rangeEnd = [wholeStr rangeOfString:@"[/url]"];
                NSRange rangeSource = NSMakeRange(rangeBegin.location + 1, rangeEnd.location - rangeBegin.location - 1);
                NSString *sourceStr = [wholeStr substringWithRange:rangeSource];
                highlight.userInfo = @{BYSourceTextKey : sourceStr, BYSourceUrlKey : urlStr};
                
                NSRange newSourceRange = NSMakeRange(sourceRange.location, rangeSource.length);
                [text replaceCharactersInRange:sourceRange withString:sourceStr];
                //设置下划线
//                [text yy_setUnderlineStyle:NSUnderlineStyleSingle range:newSourceRange];
                [text yy_setTextHighlightRange:newSourceRange color:[UIColor blueColor] backgroundColor:nil tapAction:nil];
                [text yy_setTextHighlight:highlight range:newSourceRange];
                
                //偏移量累计
                sourceClipLength += wholeStr.length - sourceStr.length;
            }
        }
    }
    
    // 匹配 网址
    {
        NSArray *httpResults = [[self regexHttp] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *http in httpResults) {
            
            if (http.range.location == NSNotFound && http.range.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:http.range.location] == nil) {
                
                //设置高亮
                
                YYTextHighlight *highlight = [YYTextHighlight new];
                
                [highlight setColor:[UIColor blueColor]];
                
                [highlight setBackgroundBorder:highlightBorder];
                
                
                highlight.userInfo = @{BYHttpKey : [text.string substringWithRange:NSMakeRange(http.range.location, http.range.length)]};
                //设置下划线
                [text yy_setUnderlineStyle:NSUnderlineStyleSingle range:http.range];
                [text yy_setTextHighlightRange:http.range color:[UIColor blueColor] backgroundColor:nil tapAction:nil];
                [text yy_setTextHighlight:highlight range:http.range];
            }
        }
    }
    
    // 匹配 @用户名
    {
        NSArray *atResults = [[self regexAt] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *at in atResults) {
            
            if (at.range.location == NSNotFound && at.range.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
                
                //设置高亮
                YYTextHighlight *highlight = [YYTextHighlight new];
                
                [highlight setColor:[UIColor orangeColor]];
                
                [highlight setBackgroundBorder:highlightBorder];
                
                // [upload=1][/upload]
                highlight.userInfo = @{BYUserIdKey : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
                [text yy_setTextHighlightRange:at.range color:[UIColor blueColor] backgroundColor:nil tapAction:nil];
                [text yy_setTextHighlight:highlight range:at.range];
            }
        }
    }
    
    
    // 匹配 音乐附件
    {
        //如果有附件再匹配
        if (article.has_attachment)
        {
            NSArray *attaResults = [[self regexAttachment] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
            //偏移
            NSUInteger attaClipLength = 0;
            //取出附件里的文件
            NSArray *files = article.attachment.file;
            
            //创建数组,存放音乐附件显示在cell里的view对应的index和location
            NSMutableArray *dataArray = [NSMutableArray array];
            
            for (NSTextCheckingResult *atta in attaResults)
            {
                NSRange attaRange = atta.range;
                attaRange.location -= attaClipLength;
                if (attaRange.location == NSNotFound && attaRange.length <= 1) continue;
                
                if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:attaRange.location]) continue;
                if ([text yy_attribute:YYTextHighlightAttributeName atIndex:attaRange.location] == nil)
                {
                    
                    //设置高亮
                    YYTextHighlight *highlight = [YYTextHighlight new];
//                    BYLog(@"获取值前:%@===%@===", NSStringFromRange(attaRange), NSStringFromRange(atta.range));
                    NSInteger fileIndex = [[text.string substringWithRange:NSMakeRange(attaRange.location + 8, attaRange.length - 8 - 10)] integerValue];
                    
                    BYFile *file = nil;
                    if (fileIndex <= files.count && fileIndex > 0)
                    {
                        file = files[fileIndex - 1];
                        
                        //附件
                        NSMutableAttributedString *atta = nil;
                        if ([file.name hasSuffix:@".mp3"] || [file.name hasSuffix:@".MP3"])
                        {
                            //音乐文件
                            NSString *index = [text.string substringWithRange:NSMakeRange(attaRange.location + 8, attaRange.length - 8 - 10)];
                            highlight.userInfo = @{BYAttachmentMusicNumberKey : index};
                            
//                            BYLog(@"有音乐文件%@", file.name);
                            NSString *musicUrlStr = [NSString stringWithFormat:@"%@?oauth_token=%@", file.url, [BYBaseParam param].oauth_token];
                            BYLog(@"有音乐文件%@", musicUrlStr);
                            BYPlayerToolBar *toolBar = [[BYPlayerToolBar alloc] init];
                            CGFloat toolBarW = BYScreenW - 2 * BYBoardArticleMargin;
                            CGFloat toolBarH = 70;
                            CGFloat toolBarX = BYBoardArticleMargin;
                            toolBar.frame = CGRectMake(toolBarX, 0, toolBarW, toolBarH);
                            [toolBar.playView.singerImgView sd_setImageWithURL:[NSURL URLWithString:article.user.face_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
                            toolBar.playView.singerNameLabel.text = article.user.BYid;
                            toolBar.tag = [index integerValue];
                            if ([article.user.gender isEqualToString:@"m"]) {
                                toolBar.playView.singerNameLabel.textColor = BYMaleNameColor;
                            }else if ([article.user.gender isEqualToString:@"f"]){
                                toolBar.playView.singerNameLabel.textColor = BYFemaleNameColor;
                            }else if([article.user.gender isEqualToString:@"n"]){
                                toolBar.playView.singerNameLabel.textColor = [UIColor whiteColor];
                            }else{
                                toolBar.playView.singerNameLabel.textColor = [UIColor whiteColor];
                            }
                            toolBar.playView.musicNameLabel.text = file.name;
                            atta = [NSMutableAttributedString yy_attachmentStringWithContent:toolBar contentMode:UIViewContentModeCenter attachmentSize:toolBar.size alignToFont:[UIFont systemFontOfSize:fontSize] alignment:YYTextVerticalAlignmentCenter];
                            [text replaceCharactersInRange:attaRange withAttributedString:atta];
                            attaClipLength += attaRange.length - 1;
//                            BYLog(@"BYTextToolMusic:location:%lu", (unsigned long)attaRange.location);
                            //图片和表情一样,长度均为1
//                            [text yy_setTextHighlight:highlight range:NSMakeRange(attaRange.location, 1)];
                            
                            //添加到数组里
                            BYUserMusic *userMusic = [[BYUserMusic alloc] init];
                            userMusic.index = [index integerValue];
                            userMusic.location = attaRange.location;
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userMusic];
                            [dataArray addObject:data];
                            
                            BYIsAttaAdded *isAttaAdded = [fileBoolArray objectAtIndex:fileIndex - 1];
                            isAttaAdded.isAdded = YES;
                            [fileBoolArray replaceObjectAtIndex:fileIndex - 1 withObject:isAttaAdded];
                        }
                    }
                }
            }
            
            if (dataArray.count) {
                //如果有音乐附件,就添加到偏好设置里去
                NSArray *array = [NSArray arrayWithArray:dataArray];
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"%@%@", article.user.BYid, article.post_time]];
            }
        }
    }
    
    {
        //如果有漏下的,添加到末尾,先匹配pdf
        for (NSInteger i = 0; i < fileBoolArray.count; i++) {
            BYIsAttaAdded *check = [fileBoolArray objectAtIndex:i];
            if (!check.isAdded) {
                BYFile *file = article.attachment.file[i];
                if ([file.name hasSuffix:@".pdf"] || [file.name hasSuffix:@".PDF"] ||
                    [file.name hasSuffix:@".exe"] || [file.name hasSuffix:@".EXE"] ||
                    [file.name hasSuffix:@".swf"] || [file.name hasSuffix:@".SWF"] ||
                    [file.name hasSuffix:@".zip"] || [file.name hasSuffix:@".ZIP"] ||
                    [file.name hasSuffix:@".rar"] || [file.name hasSuffix:@".RAR"] ||
                    [file.name hasSuffix:@".apk"] || [file.name hasSuffix:@".APK"] ||
                    [file.name hasSuffix:@".ppt"] || [file.name hasSuffix:@".PPT"] ||
                    [file.name hasSuffix:@".pptx"] || [file.name hasSuffix:@".PPTX"] ||
                    [file.name hasSuffix:@".word"] || [file.name hasSuffix:@".WORD"] ||
                    [file.name hasSuffix:@".7z"] || [file.name hasSuffix:@".7Z"] ||
                    [file.name hasSuffix:@"xlsx"] || [file.name hasSuffix:@".XLSX"] ||
                    [file.name hasSuffix:@".txt"] || [file.name hasSuffix:@".TXT"]){
                    //设置高亮
                    YYTextHighlight *highlight = [YYTextHighlight new];
                    //设置图片url
                    NSString *pdfUtrStr = [NSString stringWithFormat:@"%@?oauth_token=%@", file.url, [BYBaseParam param].oauth_token];
                    //设置高亮
                    [highlight setColor:[UIColor blueColor]];
                    [highlight setBackgroundBorder:highlightBorder];
                    NSString *pdfStr = [NSString stringWithFormat:@"附件(%@) %@", file.size, file.name];
                    highlight.userInfo = @{BYPDFUrlKey : pdfUtrStr};
                    NSRange newSourceRange = NSMakeRange(text.string.length, pdfStr.length);
                    
                    NSAttributedString *pdfStrAttr = [[NSAttributedString alloc] initWithString:pdfStr];
                    [text appendAttributedString:pdfStrAttr];
                    [text yy_setTextHighlightRange:newSourceRange color:[UIColor blueColor] backgroundColor:nil tapAction:nil];
                    [text yy_setTextHighlight:highlight range:newSourceRange];
                    
                    //偏移量累计
                    //更新标记位
                    check.isAdded = YES;
                    [fileBoolArray replaceObjectAtIndex:i withObject:check];
                }
            }
        }
    }
    
    
    {
        //如果有漏下的,添加到末尾,匹配图片
        for (NSInteger i = 0; i < fileBoolArray.count; i++) {
            BYIsAttaAdded *check = [fileBoolArray objectAtIndex:i];
            if (!check.isAdded) {
                BYFile *file = article.attachment.file[i];
                if ([file.name hasSuffix:@".jpg"] || [file.name hasSuffix:@".png"] ||
                    [file.name hasSuffix:@".bmp"] || [file.name hasSuffix:@".gif"] ||
                    [file.name hasSuffix:@".JPG"] || [file.name hasSuffix:@".PNG"] ||
                    [file.name hasSuffix:@".BMP"] || [file.name hasSuffix:@".GIF"] ||
                    [file.name hasSuffix:@".jpeg"] || [file.name hasSuffix:@".JPEG"] ){
                    //附件
                    NSMutableAttributedString *atta = nil;
                    //设置高亮
                    YYTextHighlight *highlight = [YYTextHighlight new];
                    highlight.userInfo = @{BYAttachmentImageNumberKey : [NSString stringWithFormat:@"%ld", i + 1]};
                    
                    //创建imageView
                    CGFloat imgWH = BYScreenW - 2 * BYBoardArticleMargin;
                    CGFloat imgX = (BYScreenW - imgWH - BYBoardArticleMargin) * 0.5;
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, 0, imgWH, imgWH)];
                    CALayer *layer = [imgView layer];
                    layer.borderColor = [[UIColor whiteColor] CGColor];
                    layer.borderWidth = 20;
                    
                    //设置图片url
                    NSString *imgUtrStr = [NSString stringWithFormat:@"%@?oauth_token=%@", file.url, [BYBaseParam param].oauth_token];
                    //设置imgView图片大小自适应
                    imgView.contentMode = UIViewContentModeScaleAspectFit;
                    //设置图片
                    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUtrStr] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
                    [delegate.imgViewsForArticleCell addObject:imgView];
                    //转换成附件
                    atta = [NSMutableAttributedString yy_attachmentStringWithContent:imgView contentMode:UIViewContentModeCenter attachmentSize:imgView.size alignToFont:[UIFont systemFontOfSize:fontSize] alignment:YYTextVerticalAlignmentCenter];
                    NSRange newSourceRange = NSMakeRange(text.string.length, atta.length);
                    [text appendAttributedString:atta];
                    //图片和表情一样,长度均为1
                    [text yy_setTextHighlight:highlight range:newSourceRange];
                    
                    //更新标记位
                    check.isAdded = YES;
                    [fileBoolArray replaceObjectAtIndex:i withObject:check];
                }
            }
        }
    }
    
    {
        //创建数组,存放音乐附件显示在cell里的view对应的index和location
        NSMutableArray *dataArray = [NSMutableArray array];
        //如果有漏下的,添加到末尾,匹配mp3
        for (NSInteger i = 0; i < fileBoolArray.count; i++) {
            BYIsAttaAdded *check = [fileBoolArray objectAtIndex:i];
            if (!check.isAdded) {
                BYFile *file = article.attachment.file[i];
                if ([file.name hasSuffix:@".mp3"] || [file.name hasSuffix:@".MP3"]){
                    //附件
                    NSMutableAttributedString *atta = nil;
                    //设置高亮
                    YYTextHighlight *highlight = [YYTextHighlight new];
                    highlight.userInfo = @{BYAttachmentImageNumberKey : [NSString stringWithFormat:@"%ld", i + 1]};
                    
                    //音乐文件
                    NSString *index = [NSString stringWithFormat:@"%ld", i + 1];
                    highlight.userInfo = @{BYAttachmentMusicNumberKey : index};
                    
                    BYPlayerToolBar *toolBar = [[BYPlayerToolBar alloc] init];
                    CGFloat toolBarW = BYScreenW - 2 * BYBoardArticleMargin;
                    CGFloat toolBarH = 70;
                    CGFloat toolBarX = BYBoardArticleMargin;
                    toolBar.frame = CGRectMake(toolBarX, 0, toolBarW, toolBarH);
                    [toolBar.playView.singerImgView sd_setImageWithURL:[NSURL URLWithString:article.user.face_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
                    toolBar.playView.singerNameLabel.text = article.user.BYid;
                    toolBar.tag = [index integerValue];
                    if ([article.user.gender isEqualToString:@"m"]) {
                        toolBar.playView.singerNameLabel.textColor = BYMaleNameColor;
                    }else if ([article.user.gender isEqualToString:@"f"]){
                        toolBar.playView.singerNameLabel.textColor = BYFemaleNameColor;
                    }else if([article.user.gender isEqualToString:@"n"]){
                        toolBar.playView.singerNameLabel.textColor = [UIColor whiteColor];
                    }else{
                        toolBar.playView.singerNameLabel.textColor = [UIColor whiteColor];
                    }
                    toolBar.playView.musicNameLabel.text = file.name;
                    atta = [NSMutableAttributedString yy_attachmentStringWithContent:toolBar contentMode:UIViewContentModeCenter attachmentSize:toolBar.size alignToFont:[UIFont systemFontOfSize:fontSize] alignment:YYTextVerticalAlignmentCenter];
                    
                    NSRange newSourceRange = NSMakeRange(text.string.length, atta.length);
                    [text appendAttributedString:atta];
                    
                    //添加到数组里
                    BYUserMusic *userMusic = [[BYUserMusic alloc] init];
                    userMusic.index = [index integerValue];
                    userMusic.location = newSourceRange.location;
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userMusic];
                    [dataArray addObject:data];
                    
                    //图片和表情一样,长度均为1
                    [text yy_setTextHighlight:highlight range:newSourceRange];
                    
                    //更新标记位
                    check.isAdded = YES;
                    [fileBoolArray replaceObjectAtIndex:i withObject:check];
                }
            }
        }
        if (dataArray.count) {
            //如果有音乐附件,就添加到偏好设置里去
            NSArray *array = [NSArray arrayWithArray:dataArray];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"%@%@", article.user.BYid, article.post_time]];
        }
    }
    
    {
        for (NSInteger i = 0; i < fileBoolArray.count; i++) {
            BYIsAttaAdded *check = [fileBoolArray objectAtIndex:i];
            if (!check.isAdded){
                BYFile *file = article.attachment.file[i];
                BYLog(@"还有附件没匹配到%@===%@", file.name, file.url);
            }
        }
    }
    
    return text;
}


/**
 *  正则匹配@
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexAt{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@" @[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 *  正则匹配size字体
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexSize{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[size=[1-9]+[0-9]*\\]((?!(\\[size=[1-9]+[0-9]*\\]|\\[/size\\]))(.|\n))*\\[/size\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 *  正则匹配b加粗字体
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexB{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[b\\]((?!(\\[b\\]|\\[/b\\]))(.|\n))*\\[/b\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 *  正则匹配u下划线字体
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexU{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[u\\]((?!(\\[u\\]|\\[/u\\]))(.|\n))*\\[/u\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 *  正则匹配i斜体字体
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexI{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[i\\]((?!(\\[i\\]|\\[/i\\]))(.|\n))*\\[/i\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 *  正则匹配颜色color斜体字体
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexColor{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[color=#[0-9A-Fa-f]{6}\\]((?!(\\[color=#[0-9A-Fa-f]{6}\\]|\\[/color\\]))(.|\n))*\\[/color\\]" options:kNilOptions error:NULL];
    });
    return regex;
}





/**
 *  正则匹配附件
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexAttachment{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[upload=[1-9]+[0-9]*\\]\\[/upload\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 *  正则匹配大表情
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexBigEmoticon{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[em[a|b|c](0|[1-9][0-9]*)\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 *  正则匹配小表情
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexSmallEmoticon{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[em(0|[1-9][0-9]*)\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 *  正则匹配网址
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexHttp{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#\\!]*[\\w\\-\\@?^=%&amp;/~\\+#\\!])?" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 *  正则匹配发自哪个客户端
 *
 *  @return 匹配表达式
 */
+ (NSRegularExpression *)regexSource{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[url=(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?\\].*\\[\\/url\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSString *)getUrlFromSourceWholeStr:(NSString *)wholeStr{
    NSRange rangeBegin = [wholeStr rangeOfString:@"[url="];
    NSRange rangeEnd = [wholeStr rangeOfString:@"]"];
    NSRange rangeUrl = NSMakeRange(rangeBegin.location + rangeBegin.length, rangeEnd.location - (rangeBegin.location + rangeBegin.length));
    return [wholeStr substringWithRange:rangeUrl];
}



@end
