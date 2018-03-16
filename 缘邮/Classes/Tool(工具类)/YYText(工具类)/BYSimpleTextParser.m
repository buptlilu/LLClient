//
//  BYTextParser.m
//  缘邮
//
//  Created by LiLu on 16/2/28.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYSimpleTextParser.h"
#import "BYTextTool.h"
#import "NSAttributedString+YYText.h"

#import "YYText.h"
#import "NSAttributedString+YYText.h"
#import "YYImage.h"

@interface BYSimpleTextParser () <YYTextParser>

@end

@implementation BYSimpleTextParser

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange{
    text.yy_color = [UIColor blackColor];

    
    {
        // 匹配大表情
        NSUInteger emoBigClipLength = 0;
        NSArray *emBigResults = [[BYTextTool regexBigEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *emBig in emBigResults) {
            if (emBig.range.location == NSNotFound && emBig.range.length <= 1) continue;
            
            NSRange range = emBig.range;
            range.location -= emoBigClipLength;
            
            if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        
            //把表情换成表情图片
            NSString *emoStr = [text.string substringWithRange:range];
            
            YYImage *image = [YYImage imageNamed:[NSString stringWithFormat:@"%@.gif", emoStr]];
            
            if (image) {
                //图片不为空,就替换成表情
                NSMutableAttributedString *emoBigText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:40];
                //设置回显,你显示的时候是替换了,但是用的时候还得换回来
                [emoBigText yy_setTextBackedString:[YYTextBackedString stringWithString:emoStr] range:NSMakeRange(0, emoBigText.length)];
                //替换
                [text replaceCharactersInRange:range withAttributedString:emoBigText];
                [text yy_removeDiscontinuousAttributesInRange:NSMakeRange(range.location, emoBigText.length)];
                [text addAttributes:emoBigText.yy_attributes range:NSMakeRange(range.location, emoBigText.length)];
                
                //调整光标位置
                if (selectedRange) {
                    *selectedRange = [self _replaceTextInRange:range withLength:emoBigText.length selectedRange:*selectedRange];
                }
                
                emoBigClipLength += range.length - emoBigText.length;
            }
        }
    }
    
    {
        // 匹配小表情
        NSUInteger emoSmallClipLength = 0;
        NSArray *emSmallResults = [[BYTextTool regexSmallEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *emSmall in emSmallResults) {
            if (emSmall.range.location == NSNotFound && emSmall.range.length <= 1) continue;
            
            NSRange range = emSmall.range;
            range.location -= emoSmallClipLength;
            
            if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            
            //把表情换成表情图片
            NSString *emoStr = [text.string substringWithRange:range];
            
            YYImage *image = [YYImage imageNamed:[NSString stringWithFormat:@"%@.gif", emoStr]];
            
            if (image) {
                //图片不为空,就替换成表情
                NSMutableAttributedString *emoSmallText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:15];
                //设置回显,你显示的时候是替换了,但是用的时候还得换回来
                [emoSmallText yy_setTextBackedString:[YYTextBackedString stringWithString:emoStr] range:NSMakeRange(0, emoSmallText.length)];
                //替换
                [text replaceCharactersInRange:range withAttributedString:emoSmallText];
                [text yy_removeDiscontinuousAttributesInRange:NSMakeRange(range.location, emoSmallText.length)];
                [text addAttributes:emoSmallText.yy_attributes range:NSMakeRange(range.location, emoSmallText.length)];
                
                //调整光标位置
                if (selectedRange) {
                    *selectedRange = [self _replaceTextInRange:range withLength:emoSmallText.length selectedRange:*selectedRange];
                }
                
                emoSmallClipLength += range.length - emoSmallText.length;
            }
        }
    }
//    下面是源码里的模板代码
//    NSMutableAttributedString *atr = [NSAttributedString yy_attachmentStringWithEmojiImage:emoticon fontSize:fontSize];
//    [atr yy_setTextBackedString:[YYTextBackedString stringWithString:subStr] range:NSMakeRange(0, atr.length)];
//    [text replaceCharactersInRange:oneRange withString:atr.string];
//    [text yy_removeDiscontinuousAttributesInRange:NSMakeRange(oneRange.location, atr.length)];
//    [text addAttributes:atr.yy_attributes range:NSMakeRange(oneRange.location, atr.length)];
//    selectedRange = [self _replaceTextInRange:oneRange withLength:atr.length selectedRange:selectedRange];
//    cutLength += oneRange.length - 1;
    
    
    {
        // 匹配 网址
        NSArray *httpResults = [[BYTextTool regexHttp] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *http in httpResults) {
            
            if (http.range.location == NSNotFound && http.range.length <= 1) continue;
            
           [text yy_setTextHighlightRange:http.range color:[UIColor blueColor] backgroundColor:nil tapAction:nil];
        }
    }
    
    {
        // 匹配 @用户名
        NSArray *atResults = [[BYTextTool regexAt] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *at in atResults) {
            
            if (at.range.location == NSNotFound && at.range.length <= 1) continue;
            [text yy_setTextHighlightRange:at.range color:[UIColor blueColor] backgroundColor:nil tapAction:nil];
        }
    }
    
    text.yy_font = BYMailContentFont;
    return YES;
}

//调整替换后光标位置
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange {
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}


@end
