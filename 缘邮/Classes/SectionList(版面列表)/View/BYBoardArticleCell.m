//
//  BYBoardArticleCell.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoardArticleCell.h"
#import "BYUser.h"
#import "BYArticle.h"
#import "BYBoardArticleFrame.h"

#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"

@interface BYBoardArticleCell ()

@property(nonatomic, weak) UIImageView *userIconView;

@property(nonatomic, weak) UILabel *userNameLabel;

@property(nonatomic, weak) UILabel *timeLabel;

/**
 *  文章回复数
 */
@property(nonatomic, weak) UILabel *replyCountLabel;

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UIView *spaceView;
@end

@implementation BYBoardArticleCell

//注意：cell是用initWithStyle初始化，重写这个方法即可
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加所有子控件
        [self setUpAllChildView];
    }
    return self;
}

-(void)setUpAllChildView{
    //头像
    UIImageView *userIconView = [[UIImageView alloc] init];
    [self addSubview:userIconView];
    _userIconView = userIconView;
    
    //名字
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.font = BYBoardArticleUserNameFont;
    userNameLabel.numberOfLines = 0;
    [self addSubview:userNameLabel];
    _userNameLabel = userNameLabel;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = BYBoardArticleTimeFont;
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    //回复数量
    UILabel *replyCountLabel = [[UILabel alloc] init];
    replyCountLabel.font = BYBoardArticleReplyCountFont;
    replyCountLabel.textColor = [UIColor lightGrayColor];
    replyCountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:replyCountLabel];
    _replyCountLabel = replyCountLabel;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = BYBoardArticleTitleFont;
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    //分割线
    UIView *spaceView = [UIView spaceView];
    [self addSubview:spaceView];
    self.spaceView = spaceView;
}

-(void)setBoardArticleFrame:(BYBoardArticleFrame *)boardArticleFrame{
    _boardArticleFrame = boardArticleFrame;
    
    //设置数据
    [self setUpData];
    
    //设置frame
    [self setUpFrame];
}

-(void)setUpData{
    //头像
    [_userIconView sd_setImageWithURL: [NSURL URLWithString:_boardArticleFrame.article.user.face_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //名字id
    NSString *userName = _boardArticleFrame.article.user.BYid;
    if (!userName) {
        userName = @"原帖已删除";
    }
    _userNameLabel.text = userName;
    if ([_boardArticleFrame.article.user.gender isEqualToString:@"m"]) {
        _userNameLabel.textColor = BYMaleNameColor;
    }else if ([_boardArticleFrame.article.user.gender isEqualToString:@"f"]){
        _userNameLabel.textColor = BYFemaleNameColor;
    }else if([_boardArticleFrame.article.user.gender isEqualToString:@"n"]){
        _userNameLabel.textColor = [UIColor lightGrayColor];
    }else{
        _userNameLabel.textColor = [UIColor lightGrayColor];
    }
    
    //回复
    _replyCountLabel.text = _boardArticleFrame.article.replyCountText;
    
    //标题
    _titleLabel.text = _boardArticleFrame.article.title;
    if (_boardArticleFrame.article.is_top) {
        _titleLabel.textColor = [UIColor redColor];
    }else{
        _titleLabel.dk_textColorPicker = DKColor_TEXTCOLOR_TITLE;
    }
    
    //时间
    _timeLabel.text = _boardArticleFrame.article.post_time_text;
}

//设置frame
-(void)setUpFrame{
    //头像
    _userIconView.frame = _boardArticleFrame.userIconViewFrame;
    
    //名字
    _userNameLabel.frame = _boardArticleFrame.userNameLabelFrame;
    
    //回复
    _replyCountLabel.frame = _boardArticleFrame.replyCountLabelFrame;
    
    //时间
    _timeLabel.frame = _boardArticleFrame.timeLabelFrame;
    
    //标题
    //    BYLog(@"%lld", _boardArticleFrame.article.post_time);
    _titleLabel.frame = _boardArticleFrame.titleLabelFrame;
    
    //分割线
    _spaceView.frame = _boardArticleFrame.spaceViewFrame;
}
@end
