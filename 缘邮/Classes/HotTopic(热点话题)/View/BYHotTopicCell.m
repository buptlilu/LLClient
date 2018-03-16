//
//  BYHotTopicCell.m
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYHotTopicCell.h"
#import "BYArticle.h"
#import "BYHotTopicFrame.h"

@interface BYHotTopicCell ()

/**
 *  文章所属版面
 */
@property(nonatomic, weak) UILabel *articleBoardLabel;

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UILabel *timeLabel;

/**
 *  文章回复数
 */
@property(nonatomic, weak) UILabel *replyCountLabel;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *spaceView;
@end

@implementation BYHotTopicCell

//注意：cell是用initWithStyle初始化，重写这个方法即可
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加所有子控件
        [self setUpAllChildView];
    }
    return self;
}

-(void)setUpAllChildView{
    
    //版面
    UILabel *articleBoardLabel = [[UILabel alloc] init];
    articleBoardLabel.font = BYArticleBoardFont;
    articleBoardLabel.dk_textColorPicker = DKColor_TEXTCOLOR_HINT;
    articleBoardLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:articleBoardLabel];
    _articleBoardLabel = articleBoardLabel;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = BYBoardArticleTimeFont;
    timeLabel.dk_textColorPicker = DKColor_TEXTCOLOR_HINT;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    //回复数量
    UILabel *replyCountLabel = [[UILabel alloc] init];
    replyCountLabel.font = BYBoardArticleReplyCountFont;
    replyCountLabel.dk_textColorPicker = DKColor_TEXTCOLOR_HINT;
    replyCountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:replyCountLabel];
    _replyCountLabel = replyCountLabel;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = BYBoardArticleTitleFont;
    titleLabel.dk_textColorPicker = DKColor_TEXTCOLOR_TITLE;
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIView *spaceView = [UIView spaceView];
    [self addSubview:spaceView];
    self.spaceView = spaceView;
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    [self addSubview:arrowView];
    self.arrowView = arrowView;
}

- (void)setHotTopicFrame:(BYHotTopicFrame *)hotTopicFrame{
    _hotTopicFrame = hotTopicFrame;
    
    //设置数据
    [self setUpData];
    
    //设置frame
    [self setUpFrame];
}

-(void)setUpData{
    //版面
    _articleBoardLabel.text = _hotTopicFrame.article.board_name;
    
    //回复
    _replyCountLabel.text = _hotTopicFrame.article.replyCountText;
    
    //标题
    _titleLabel.text = _hotTopicFrame.article.title;
    
    //时间
    _timeLabel.text = _hotTopicFrame.article.post_time_text;
}

//设置frame
-(void)setUpFrame{
    //版面
    _articleBoardLabel.frame = _hotTopicFrame.articleBoardFrame;
    
    //回复
    _replyCountLabel.frame = _hotTopicFrame.replyCountLabelFrame;
    
    //时间
    _timeLabel.frame = _hotTopicFrame.timeLabelFrame;
    
    //标题
    //    BYLog(@"%lld", _boardArticleFrame.article.post_time);
    _titleLabel.frame = _hotTopicFrame.titleLabelFrame;
    
    _arrowView.frame = _hotTopicFrame.arrowViewFrame;
    
    _spaceView.frame = _hotTopicFrame.spaceViewFrame;
}
@end
