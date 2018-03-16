//
//  BYUserView.m
//  缘邮
//
//  Created by LiLu on 15/12/6.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYUserView.h"
#import "BYArticleFrame.h"
#import "BYUser.h"
#import "BYTextTool.h"
#import "BYArticle.h"
#import "BYMeTool.h"
#import "BYMeDetailController.h"
#import "BYPlayerToolBar.h"
#import "BYArticleTool.h"
#import "BYArticleParam.h"
#import "BYLikeParam.h"
#import "BYArticleLikeResult.h"
#import "UIButton+Extensions.h"

#import "YYText.h"
#import "NSDate+MJ.h"
#import "UIImageView+WebCache.h"
#import "DCPathItemButton.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"

@interface BYUserView() <DCPathItemButtonDelegate, YYTextViewDelegate, UIAlertViewDelegate>
/**
 *  头像
 */
@property(nonatomic, weak) UIImageView *userIconView;
/**
 *  用户名
 */
@property(nonatomic, weak) UILabel *userNameView;
/**
 *  评论时间
 */
@property(nonatomic, weak) UILabel *userTimeView;
/**
 *  用户楼层位置
 */
@property(nonatomic, weak) UILabel *userPositionView;

/**
 *  赞的图片
 */
@property(nonatomic, weak) UIButton *likeBtn;



/**
 *  回复工具条
 */
@property (nonatomic, weak) UIButton *replyBtn;

/**
 *  动画移动的距离
 */
@property (assign, nonatomic) CGFloat bloomRadius;

/**
 *  保存回复的几个按钮
 */
@property (nonatomic, strong) NSMutableArray *btnItems;

/**
 *  当前状态,是否为展开
 */
@property (nonatomic, assign) BOOL isBloom;
@property (nonatomic, weak) UIView *spaceView;
@end

@implementation BYUserView

- (NSMutableArray *)btnItems{
    if (!_btnItems) {
        _btnItems = [NSMutableArray array];
        
        DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"replyiPhoneSpootlight7_40pt"]
                                                               highlightedImage:[UIImage imageNamed:@"replyiPhoneSpootlight7_40pt"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"atiPhoneSpootlight7_40pt"]
                                                               highlightedImage:[UIImage imageNamed:@"atiPhoneSpootlight7_40pt"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"sendMailiPhoneSpootlight7_40pt"]
                                                               highlightedImage:[UIImage imageNamed:@"sendMailiPhoneSpootlight7_40pt"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        [self.btnItems addObject:itemButton_1];
        [self.btnItems addObject:itemButton_2];
        [self.btnItems addObject:itemButton_3];
        
        itemButton_1.backgroundColor = [UIColor clearColor];
        itemButton_2.backgroundColor = [UIColor clearColor];
        itemButton_3.backgroundColor = [UIColor clearColor];
        
        [self addSubview:itemButton_1];
        [self addSubview:itemButton_2];
        [self addSubview:itemButton_3];
        
    }
    return _btnItems;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpAllChildView];
        self.userInteractionEnabled = YES;
//        self.image = [UIImage imageWithStretchableName:@"timeline_card_top_background"];
    }
    return self;
}

-(void)setUpAllChildView{
    //头像
    UIImageView *userIconView = [[UIImageView alloc] init];
    userIconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserIcon:)];
    [userIconView addGestureRecognizer:singleTap1];
    [self addSubview:userIconView];
    _userIconView = userIconView;
    
    //用户名
    UILabel *userNameView =[[UILabel alloc] init];
    userNameView.font = BYBoardArticleUserNameFont;
    userNameView.numberOfLines = 0;
    userNameView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserIcon:)];
    [userNameView addGestureRecognizer:singleTap2];
    [self addSubview:userNameView];
    _userNameView = userNameView;
    
    //评论时间
    UILabel *userTimeView = [[UILabel alloc] init];
    userTimeView.font = BYBoardArticleTimeFont;
    userTimeView.textColor = [UIColor lightGrayColor];
    [self addSubview:userTimeView];
    _userTimeView = userTimeView;
    
    //获赞数
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"timeline_icon_unlike@2x.png"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn.userInteractionEnabled = NO;
    btn.titleLabel.font = BYArticlePositionFont;
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn setHitTestEdgeInsets:UIEdgeInsetsMake(-5, -5, -5, -5)];
    _likeBtn = btn;
    
    //用户所在楼层
    UILabel *userPositionView = [[UILabel alloc] init];
    userPositionView.font = BYArticlePositionFont;
    userPositionView.textColor = [UIColor lightGrayColor];
    userPositionView.textAlignment = NSTextAlignmentRight;
    [self addSubview:userPositionView];
    _userPositionView = userPositionView;
    
    //评论内容
    YYTextView *articleContentView = [[YYTextView alloc] init];
    articleContentView.scrollEnabled = NO;
    articleContentView.editable = NO;
    articleContentView.textColor = [UIColor blackColor];
//    articleContentView.backgroundColor = [UIColor blueColor];
//    articleContentView.displaysAsynchronously = YES;
//    articleContentView.ignoreCommonProperties = YES;
//    articleContentView.fadeOnHighlight = NO;
//    articleContentView.fadeOnAsynchronouslyDisplay = NO;
//    articleContentView.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        YYLabel *la = (YYLabel *)containerView;
//        NSAttributedString *textHi = la.textLayout.text;
////        BYLog(@"%@==%@===%@", text, textHi,git  [containerView class]);
////        BYLog(@"class===%@***%@", [containerView class], [[text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location] class]);
////        YYTextAttachment *attr = [text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location];
////        BYLog(@"location:%lu", (unsigned long)range.location);
////        BYLog(@"---%@", [attr.content class]);
//        
//        YYTextHighlight *highlight = [textHi yy_attribute:YYTextHighlightAttributeName atIndex:range.location];
//        NSDictionary *info = highlight.userInfo;
//        if (info.count == 0) {
//            return;
//        }
//        
//        //@某人
//        if (info[BYUserIdKey]) {
//            if ([self.delegate respondsToSelector:@selector(contentViewDidClickUserId:)]) {
//                [self.delegate contentViewDidClickUserId:info[BYUserIdKey]];
//            }
//            return;
//        }
//        
//        //图片附件index
//        if (info[BYAttachmentImageNumberKey]) {
//            if ([self.delegate respondsToSelector:@selector(contentViewDidClickImage:)]) {
//                [self.delegate contentViewDidClickImage:[info[BYAttachmentImageNumberKey] integerValue]];
//            }
//            return;
//        }
//        
//        //发自某个客户端
//        if (info[BYSourceUrlKey]) {
//            if ([self.delegate respondsToSelector:@selector(contentViewDidClickLink:)]) {
//                [self.delegate contentViewDidClickLink:info[BYSourceUrlKey]];
//            }
//            return;
//        }
//        
//        //pdf附件
//        if (info[BYPDFUrlKey]) {
//            if ([self.delegate respondsToSelector:@selector(contentViewDidClickLink:)]) {
//                [self.delegate contentViewDidClickLink:info[BYPDFUrlKey]];
//            }
//            return;
//        }
//        
//        //网页链接
//        if (info[BYHttpKey]) {
//            if ([self.delegate respondsToSelector:@selector(contentViewDidClickLink:)]) {
//                [self.delegate contentViewDidClickLink:info[BYHttpKey]];
//            }
//            return;
//        }
//        
//    };
    articleContentView.font = [UIFont systemFontOfSize:14];
    articleContentView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    articleContentView.delegate = self;
    [self addSubview:articleContentView];
    _articleContentView = articleContentView;
    
    //设置动画按钮
    [self setUpReplyBtn];
    
    UIView *spaceView = [UIView spaceView];
    [self addSubview:spaceView];
    self.spaceView = spaceView;
}

#pragma mark YYTextView代理方法
- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight1 inRange:(NSRange)characterRange rect:(CGRect)rect{
    NSAttributedString *textHi = textView.textLayout.text;
    //        BYLog(@"%@==%@===%@", text, textHi, [containerView class]);
    //        BYLog(@"class===%@***%@", [containerView class], [[text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location] class]);
    //        YYTextAttachment *attr = [text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location];
    //        BYLog(@"location:%lu", (unsigned long)range.location);
    //        BYLog(@"---%@", [attr.content class]);
    
    YYTextHighlight *highlight = [textHi yy_attribute:YYTextHighlightAttributeName atIndex:characterRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) {
        return;
    }
    
    //@某人
    if (info[BYUserIdKey]) {
        if ([self.delegate respondsToSelector:@selector(contentViewDidClickUserId:)]) {
            [self.delegate contentViewDidClickUserId:info[BYUserIdKey]];
        }
        return;
    }
    
    //图片附件index
    if (info[BYAttachmentImageNumberKey]) {
        if ([self.delegate respondsToSelector:@selector(contentViewDidClickImage:)]) {
            [self.delegate contentViewDidClickImage:[info[BYAttachmentImageNumberKey] integerValue]];
        }
        return;
    }
    
    //发自某个客户端
    if (info[BYSourceUrlKey]) {
        if ([self.delegate respondsToSelector:@selector(contentViewDidClickLink:)]) {
            [self.delegate contentViewDidClickLink:info[BYSourceUrlKey]];
        }
        return;
    }
    
    //pdf附件
    if (info[BYPDFUrlKey]) {
        if ([self.delegate respondsToSelector:@selector(contentViewDidClickLink:)]) {
            [self.delegate contentViewDidClickLink:info[BYPDFUrlKey]];
        }
        return;
    }
    
    //网页链接
    if (info[BYHttpKey]) {
        if ([self.delegate respondsToSelector:@selector(contentViewDidClickLink:)]) {
            [self.delegate contentViewDidClickLink:info[BYHttpKey]];
        }
        return;
    }

}

#pragma mark 点击头像时候调用
- (void)clickUserIcon:(UITapGestureRecognizer *) tag{
    if ([self.delegate respondsToSelector:@selector(contentViewDidClickUserId:)]) {
        [self.delegate contentViewDidClickUserId:_articleFrame.article.user.BYid];
    }
}

#pragma mark 点赞
- (void)likeBtnClick:(UIButton *) btn{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"点赞" message:@"确认给本楼层点个赞? (将扣取3积分送给层主)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d", buttonIndex);
    if (buttonIndex == 1) {
        BYLikeParam *param = [BYLikeParam param];
        param.id = _articleFrame.article.BYid;
        param.name = _articleFrame.article.board_name;
        param.up = @"1";
        BYLog(@"点赞:%d--%@", param.id, param.name);
        [BYArticleTool likeArticleWithArticleParam:param whenSuccess:^(BYArticleLikeResult *result) {
            //点赞成功
            [MBProgressHUD showSuccess:@"点赞成功"];
            
            //赞
            int like_sum = result.like_sum;
            if (like_sum > 0) {
                [_likeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else{
                [_likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            [_likeBtn setTitle:[NSString stringWithFormat:@"%d", like_sum] forState:UIControlStateNormal];
        } whenfailure:^(NSError *error) {
            [MBProgressHUD showError:@"点赞失败"];
            BYLog(@"%@", error);
        }];
    }
}

#pragma mark 动画相关的
- (void)setUpReplyBtn{
    UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyBtn setImage:[UIImage imageNamed:@"small_main_menuiPhoneSpootlight7_40pt"] forState:UIControlStateNormal];
    [replyBtn setImage:[UIImage imageNamed:@"small_main_menuiPhoneSpootlight7_40pt"] forState:UIControlStateHighlighted];
    [replyBtn addTarget:self action:@selector(replyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.bloomRadius = BYScreenW * 0.24;
    [self addSubview:replyBtn];
    _replyBtn = replyBtn;
}

- (void)replyBtnClick:(UIButton *)btn{
    self.isBloom = !self.isBloom;
    if (self.isBloom) {
        //展开
        [self btnItemsBloom];
    }else{
        //折叠
        [self btnItemsFold];
    }
}

- (void)itemButtonTapped:(DCPathItemButton *)itemButton{
    DCPathItemButton *selectedButton = self.btnItems[itemButton.tag];
    
    if (self.isBloom) {
        //如果是展开状态,就收起来
        // Play selected sound
        //
        
        // Excute the explode animation when the item is seleted
        //
        [UIView animateWithDuration:0.0618f * 5
                         animations:^{
                             selectedButton.transform = CGAffineTransformMakeScale(3, 3);
                             selectedButton.alpha = 0.0f;
                         }];
        
        // Excute the dismiss animation when the item is unselected
        //
        for (int i = 0; i < self.btnItems.count; i++) {
            if (i == selectedButton.tag) {
                continue;
            }
            DCPathItemButton *unselectedButton = self.btnItems[i];
            [UIView animateWithDuration:0.0618f * 2
                             animations:^{
                                 unselectedButton.transform = CGAffineTransformMakeScale(0, 0);
                             }];
        }
        
        // Excute the delegate method
        //
        
        // Resize the DCPathButton's frame
        //
        [self resizeToFoldedFrame];
    }
    
    self.isBloom = NO;
    
    if ([self.delegate respondsToSelector:@selector(replyItemsDidClick:)]) {
        [self.delegate replyItemsDidClick:selectedButton.tag];
    }
    
//    NSLog(@"哈哈,点击了%ld", (long)itemButton.tag);
//    BYLog(@"reply===%@", NSStringFromCGRect(_replyBtn.frame));
//    BYLog(@"item===%@", NSStringFromCGRect(selectedButton.frame));
}


#pragma mark - Center Button Bloom  展开

- (void)btnItemsBloom
{
    // Play bloom sound
    //
//    NSLog(@"点击2");
    
    // Configure center button bloom
    //
    // 1. Store the current center point to 'centerButtonBloomCenter
    //
    //    self.pathCenterButtonBloomCenter = self.center;
    
    // 2. Resize the DCPathButton's frame
    //
    
    
    // 3. Excute the bottom view alpha animation
    //
    //    [UIView animateWithDuration:0.0618f * 3
    //                          delay:0.0f
    //                        options:UIViewAnimationOptionCurveEaseIn
    //                     animations:^{
    //                         _bottomView.alpha = 0.618f;
    //                     }
    //                     completion:nil];
    
    // 4. Excute the center button rotation animation
    //
    [UIView animateWithDuration:0.1575f
                     animations:^{
                         self.replyBtn.transform = CGAffineTransformMakeRotation(-0.75f * M_PI);
                     }];
    
    //    self.pathCenterButton.center = self.pathCenterButtonBloomCenter;
    
    // 5. Excute the bloom animation
    //
    //这里改初始弹出每个按钮的夹角
//    CGFloat basicAngel = 180 / 2 / (self.btnItems.count - 1);
    
    for (int i = 1; i <= self.btnItems.count; i++) {
        
        DCPathItemButton *pathItemButton = self.btnItems[i - 1];
        
        pathItemButton.delegate = self;
        pathItemButton.tag = i - 1;
        pathItemButton.transform = CGAffineTransformMakeTranslation(1, 1);
        pathItemButton.alpha = 1.0f;
        
        // 1. Add pathItem button to the view
        //
        //这里改每个按钮与左边水平方向的总夹角
//        CGFloat currentAngel = (basicAngel * (i - 1))/180;
        
        pathItemButton.center = self.replyBtn.center;
        
        //        [self insertSubview:pathItemButton belowSubview:self.pathCenterButton];
        
        // 2.Excute expand animation
        //
        
        CGPoint endPoint = [self createEndPointWithRadius:self.bloomRadius * i andAngel:0];
        CGPoint farPoint = [self createEndPointWithRadius:self.bloomRadius * 1.2 * i andAngel:0];
        CGPoint nearPoint = [self createEndPointWithRadius:self.bloomRadius * 0.9 * i andAngel:0];
        
//        CGPoint endPoint = [self createEndPointWithRadius:self.bloomRadius andAngel:currentAngel];
//        CGPoint farPoint = [self createEndPointWithRadius:self.bloomRadius + 10.0f andAngel:currentAngel];
//        CGPoint nearPoint = [self createEndPointWithRadius:self.bloomRadius - 5.0f andAngel:currentAngel];
        
        CAAnimationGroup *bloomAnimation = [self bloomAnimationWithEndPoint:endPoint
                                                                andFarPoint:farPoint
                                                               andNearPoint:nearPoint];
        
        [pathItemButton.layer addAnimation:bloomAnimation forKey:@"bloomAnimation"];
        pathItemButton.center = endPoint;
//        NSLog(@"center:%@", NSStringFromCGPoint(pathItemButton.center));
    }
}

- (void)btnItemsFold
{
    // Play fold sound
    //
//    NSLog(@"点击1");
    
    // Load item buttons from array
    //
    for (int i = 1; i <= self.btnItems.count; i++) {
        
        DCPathItemButton *itemButton = self.btnItems[i - 1];
        
//        CGFloat currentAngel = (i - 1)/ ((CGFloat)self.btnItems.count + 1);
        CGPoint farPoint = [self createEndPointWithRadius:self.bloomRadius + 5.0f andAngel:0];
        
        CAAnimationGroup *foldAnimation = [self foldAnimationFromPoint:itemButton.center withFarPoint:farPoint];
        
        [itemButton.layer addAnimation:foldAnimation forKey:@"foldAnimation"];
        itemButton.center = self.replyBtn.center;
        
    }
    
    
    // Resize the DCPathButton's frame to the foled frame and remove the item buttons
    //
    [self resizeToFoldedFrame];
}

- (void)resizeToFoldedFrame
{
    [UIView animateWithDuration:0.0618f * 3
                          delay:0.0618f * 2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.replyBtn.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:nil];
    
    //    [UIView animateWithDuration:0.1f
    //                          delay:0.35f
    //                        options:UIViewAnimationOptionCurveLinear
    //                     animations:^{
    //                         _bottomView.alpha = 0.0f;
    //                     }
    //                     completion:nil];
    
}


#pragma mark - Caculate The Item's End Point

- (CGPoint)createEndPointWithRadius:(CGFloat)itemExpandRadius andAngel:(CGFloat)angel
{
    return CGPointMake(self.replyBtn.center.x - cosf(angel * M_PI * 1) * itemExpandRadius,
                       self.replyBtn.center.y - sinf(angel * M_PI * 1) * itemExpandRadius);
}

- (CAAnimationGroup *)foldAnimationFromPoint:(CGPoint)endPoint withFarPoint:(CGPoint)farPoint
{
    // 1.Configure rotation animation
    //
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0), @(M_PI), @(M_PI * 2)];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 0.35f;
    
    // 2.Configure moving animation
    //
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // Create moving path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
    CGPathAddLineToPoint(path, NULL, self.replyBtn.center.x, self.replyBtn.center.y);
    
    movingAnimation.keyTimes = @[@(0.0f), @(0.75), @(1.0)];
    
    movingAnimation.path = path;
    movingAnimation.duration = 0.35f;
    CGPathRelease(path);
    
    // 3.Merge animation together
    //
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[rotationAnimation, movingAnimation];
    animations.duration = 0.35f;
    
    return animations;
}

- (CAAnimationGroup *)bloomAnimationWithEndPoint:(CGPoint)endPoint andFarPoint:(CGPoint)farPoint andNearPoint:(CGPoint)nearPoint
{
    // 1.Configure rotation animation
    //
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0.0), @(- M_PI), @(- M_PI * 1.5), @(- M_PI * 2)];
    rotationAnimation.duration = 0.3f;
    rotationAnimation.keyTimes = @[@(0.0), @(0.3), @(0.6), @(1.0)];
    
    // 2.Configure moving animation
    //
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // Create moving path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.replyBtn.center.x, self.replyBtn.center.y);
    CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
    CGPathAddLineToPoint(path, NULL, nearPoint.x, nearPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    movingAnimation.path = path;
    movingAnimation.keyTimes = @[@(0.0), @(0.5), @(0.7), @(1.0)];
    movingAnimation.duration = 0.3f;
    CGPathRelease(path);
    
    // 3.Merge two animation together
    //
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[movingAnimation, rotationAnimation];
    animations.duration = 0.3f;
    animations.delegate = self;
    
    return animations;
}



- (void)ConfigureDCPathButton{
//    BYLog(@"%d===%s", _articleFrame.article.position, __func__);
    self.isBloom = NO;
    
    for (DCPathItemButton *item in self.btnItems) {
        item.center = self.replyBtn.center;
    }
    
    [self bringSubviewToFront:_replyBtn];
}

#pragma mark 设置frame和data
-(void)setArticleFrame:(BYArticleFrame *)articleFrame{
    _articleFrame = articleFrame;
    
    //设置frame
    [self setUpFrame];
    
    //设置内容
    [self setUpData];
}

-(void)setUpData{
    //头像
    [_userIconView sd_setImageWithURL: [NSURL URLWithString:_articleFrame.article.user.face_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //名字id
    NSString *userName = _articleFrame.article.user.user_name;
    if (!userName) {
        userName = @"原帖已删除";
    }
    _userNameView.text = userName;
    if ([_articleFrame.article.user.gender isEqualToString:@"m"]) {
        _userNameView.textColor = BYMaleNameColor;
    }else if ([_articleFrame.article.user.gender isEqualToString:@"f"]){
        _userNameView.textColor = BYFemaleNameColor;
    }else if([_articleFrame.article.user.gender isEqualToString:@"n"]){
        _userNameView.textColor = BYUnknownSexNameColor;
    }else{
        _userNameView.text = _articleFrame.article.user.BYid;
        _userNameView.textColor = BYUnknownSexNameColor;
    }
    
    //时间
    NSDate *postTime = [NSDate dateWithTimeIntervalSince1970:[_articleFrame.article.post_time longLongValue]];
    _userTimeView.text = [postTime stringFromBYDate];
    
    //用户楼层
    if (_articleFrame.article.position == -1) {
        //为-1就隐藏
        _userPositionView.hidden = YES;
        _replyBtn.hidden = YES;
        for (DCPathItemButton *item in self.btnItems) {
            item.hidden = YES;
        }
    }else{
        //否则显示
        _userPositionView.hidden = NO;
        _replyBtn.hidden = NO;
        for (DCPathItemButton *item in self.btnItems) {
            item.hidden = NO;
        }
    }
    
    if (_articleFrame.article.position == 0) {
        _userPositionView.text = @"楼主";
    }else if (_articleFrame.article.position == 1){
        _userPositionView.text = @"沙发";
    }else if (_articleFrame.article.position == 2){
        _userPositionView.text = @"板凳";
    }else{
        _userPositionView.text = [NSString stringWithFormat:@"%d楼", _articleFrame.article.position];
    }
    
    //赞
    if (_articleFrame.article.like_sum) {
        [_likeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [_likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [_likeBtn setTitle:[NSString stringWithFormat:@"%d", _articleFrame.article.like_sum] forState:UIControlStateNormal];
    
    //正文内容
    _articleContentView.attributedText = _articleFrame.textLayout.text;
}

-(void)setUpFrame{
    //头像
    _userIconView.frame = _articleFrame.userIconFrame;
    
    //名字
    _userNameView.frame = _articleFrame.userNameFrame;
//    _userNameView.backgroundColor = [UIColor blueColor];
//    _likeBtn.backgroundColor = [UIColor redColor];
    
    //时间
    NSMutableDictionary *timeAttr = [NSMutableDictionary dictionary];
    timeAttr[NSFontAttributeName] = BYBoardArticleTimeFont;
    CGSize timeSize = [_articleFrame.article.post_time_text sizeWithAttributes:timeAttr];
    CGFloat timeX = _userNameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_userIconView.frame) - timeSize.height;
    _userTimeView.frame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    _userTimeView.text = _articleFrame.article.post_time;
    
    //用户楼层
    _userPositionView.frame = _articleFrame.userPositionFrame;
    
    //赞
    CGFloat btnY = _userNameView.frame.origin.y;
    CGFloat btnH = _userNameView.height;
    CGFloat btnW = 70;
    CGFloat btnX = BYScreenW - btnW - (BYScreenW - CGRectGetMaxX(_userPositionView.frame));
    
    //调节按钮的frame和image与title的间距
    _likeBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    _likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [_likeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    //正文
//    BYLog(@"frame:%@", NSStringFromCGRect(_articleFrame.articleContentFrame));
//    BYLog(@"contentSize:%@", NSStringFromCGSize(_articleContentView.contentSize));
//    BYLog(@"textBoundingSize:%@", NSStringFromCGSize(_articleFrame.textLayout.textBoundingSize));
    _articleContentView.frame = _articleFrame.articleContentFrame;
//    _articleContentView.contentSize = _articleFrame.textLayout.textBoundingSize;
    _articleContentView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    _articleContentView.textLayout = _articleFrame.textLayout;
    
    //设置按钮的frame
    _replyBtn.transform = CGAffineTransformMakeRotation(0);  //如果不旋转回来设置frame会出问题
    CGFloat replyBtnWH = 35;
    CGFloat replyBtnX = BYScreenW - replyBtnWH - BYBoardArticleMargin;
    CGFloat replyBtnY = CGRectGetMaxY(self.frame) - replyBtnWH - BYBoardArticleMargin;
    _replyBtn.frame = CGRectMake(replyBtnX, replyBtnY, replyBtnWH, replyBtnWH);
//    _replyBtn.backgroundColor = [UIColor blueColor];
    [self bringSubviewToFront:_replyBtn];
//    BYLog(@"===%@", NSStringFromCGRect(_replyBtn.frame));
//    self.bloomRadius = _articleFrame.cellHeight > BYScreenW ? BYScreenW * 0.3 : _articleFrame.cellHeight * 0.5;
    [self ConfigureDCPathButton];
    
    _spaceView.frame = _articleFrame.spaceViewFrame;
}
@end
