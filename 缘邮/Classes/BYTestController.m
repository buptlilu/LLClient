//
//  BYTestController.m
//  缘邮
//
//  Created by LiLu on 16/2/26.
//  Copyright © 2016年 lilu. All rights reserved.
//


#import "YYText.h"
#import "BYTestController.h"
#import "NSAttributedString+YYText.h"


@interface BYTestController ()
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout; //文本

- (IBAction)switchValueChanged:(id)sender;

@end

@implementation BYTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *testStr = @"@chujunhe124 哈哈哈  http://www.baidu.com 哈哈哈[upload=1][/upload]哈哈ddd[upload=10][/upload]ddd";
    
    _label = [YYLabel new];
    _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _label.displaysAsynchronously = YES;
    _label.ignoreCommonProperties = YES;
    _label.fadeOnHighlight = NO;
    _label.fadeOnAsynchronouslyDisplay = NO;
    @weakify(self);
    _label.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [weak_self didClickInLabel:(YYLabel *)containerView textRange:range];
    };
//    _label.backgroundColor = [UIColor redColor];
    [self layoutText:testStr];
    [self.view addSubview:_label];
//    BYLog(@"%@", NSStringFromCGRect(_label.frame));
}

- (void)layoutText:(NSString *)testStr{
    NSMutableAttributedString *text = [self textWithStr:testStr fontSize:12 textColor:[UIColor blueColor]];
    
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(200, MAXFLOAT);
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    _label.textLayout = _textLayout;
    _label.frame = CGRectMake(20, 100, _textLayout.textBoundingSize.width, _textLayout.textBoundingSize.height);
//    BYLog(@"size%@", NSStringFromCGSize(_textLayout.textBoundingSize));
    _label.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        YYLabel *la = (YYLabel *)containerView;
        NSAttributedString *textHi = la.textLayout.text;
//        BYLog(@"%@==%@", text, textHi);
        YYTextHighlight *highlight = [textHi yy_attribute:YYTextHighlightAttributeName atIndex:range.location];
        NSDictionary *info = highlight.userInfo;
        if (info.count == 0) {
            return;
        }
        
        if (info[BYUserIdKey]) {
            BYLog(@"id:%@", info[BYUserIdKey]);
            return;
        }
        
        if (info[BYAttachmentImageNumberKey]) {
            BYLog(@"attachment:%@", info[BYAttachmentImageNumberKey]);
            return;
        }
        
        if (info[BYHttpKey]) {
            BYLog(@"==%@", info[BYHttpKey]);
            return;
        }
        
    };
    if (!_textLayout) return;
}


- (NSMutableAttributedString *)textWithStr:(NSString *)testStr
                                      fontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor {
    if (!testStr) return nil;
    
    NSMutableString *string = testStr.mutableCopy;
    if (string.length == 0) return nil;
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor redColor];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = font;
    text.yy_color = textColor;
   
    
    // 根据 urlStruct 中每个 URL.shortURL 来匹配文本，将其替换为图标+友好描述
    
    // 匹配 @用户名
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
            [text yy_setTextHighlightRange:at.range color:[UIColor blackColor] backgroundColor:nil tapAction:nil];
            [text yy_setTextHighlight:highlight range:at.range];
        }
    }
    
    // 匹配 附件
    NSArray *attaResults = [[self regexAttachment] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    for (NSTextCheckingResult *atta in attaResults) {
        
        if (atta.range.location == NSNotFound && atta.range.length <= 1) continue;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:atta.range.location] == nil) {
            
            //设置高亮
            YYTextHighlight *highlight = [YYTextHighlight new];
            
            [highlight setColor:[UIColor orangeColor]];
            [highlight setBackgroundBorder:highlightBorder];
            highlight.userInfo = @{BYAttachmentImageNumberKey : [text.string substringWithRange:NSMakeRange(atta.range.location + 8, atta.range.length - 8 - 10)]};
            
            [text yy_setTextHighlightRange:atta.range color:[UIColor redColor] backgroundColor:nil tapAction:nil];
            [text yy_setTextHighlight:highlight range:atta.range];
        }
    }
    
    // 匹配 网址
    NSArray *httpResults = [[self regexHttp] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    for (NSTextCheckingResult *http in httpResults) {
        
        if (http.range.location == NSNotFound && http.range.length <= 1) continue;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:http.range.location] == nil) {
            
            //设置高亮
            YYTextHighlight *highlight = [YYTextHighlight new];
            
            [highlight setColor:[UIColor greenColor]];
            
            [highlight setBackgroundBorder:highlightBorder];
            
            
            highlight.userInfo = @{BYHttpKey : [text.string substringWithRange:NSMakeRange(http.range.location, http.range.length)]};
            [text yy_setTextHighlightRange:http.range color:[UIColor greenColor] backgroundColor:nil tapAction:nil];
            [text yy_setTextHighlight:highlight range:http.range];
        }
    }

    
            
//            // 高亮状态
//            YYTextHighlight *highlight = [YYTextHighlight new];
//            [highlight setBackgroundBorder:highlightBorder];
//            // 数据信息，用于稍后用户点击
//            highlight.userInfo = @{kWBLinkAtName : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
//            [text setTextHighlight:highlight range:at.range];
    
    // 匹配 [表情]
//    NSArray<NSTextCheckingResult *> *emoticonResults = [[WBStatusHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
//    NSUInteger emoClipLength = 0;
//    for (NSTextCheckingResult *emo in emoticonResults) {
//        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
//        NSRange range = emo.range;
//        range.location -= emoClipLength;
//        if ([text attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
//        if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
//        NSString *emoString = [text.string substringWithRange:range];
//        NSString *imagePath = [WBStatusHelper emoticonDic][emoString];
//        UIImage *image = [WBStatusHelper imageWithPath:imagePath];
//        if (!image) continue;
//        
//        NSAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:fontSize];
//        [text replaceCharactersInRange:range withAttributedString:emoText];
//        emoClipLength += range.length - 1;
//    }

    return text;
}



/// 点击了 Label 的链接
- (void)didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange{
    
}


/**
 *  正则匹配@
 *
 *  @return 匹配表达式
 */
- (NSRegularExpression *)regexAt{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}



/**
 *  正则匹配附件
 *
 *  @return 匹配表达式
 */
- (NSRegularExpression *)regexAttachment{
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
 *  正则匹配网址
 *
 *  @return 匹配表达式
 */
- (NSRegularExpression *)regexHttp{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?" options:kNilOptions error:NULL];
    });
    return regex;
}

- (IBAction)switchValueChanged:(id)sender {
    UISwitch *s = (UISwitch *)sender;
    if (s.isOn) {
        BYLog(@"kaiaaa");
    }else{
        BYLog(@"guan");
    }
}
@end
