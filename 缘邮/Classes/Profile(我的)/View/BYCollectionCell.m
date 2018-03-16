//
//  BYCollectCell.m
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYCollectionCell.h"
#import "BYCollection.h"
#import "BYCollectionFrame.h"
#import "NSDate+MJ.h"

@interface BYCollectionCell ()

/**
 *  文章所属版面
 */
@property (nonatomic, weak) UILabel *articleBoardLabel;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UIImageView *arrowView;

@property (nonatomic, weak) UIView *spaceView;
@end


@implementation BYCollectionCell


//注意：cell是用initWithStyle初始化，重写这个方法即可
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加所有子控件
        [self setUpAllChildView];
    }
    return self;
}

- (void)setUpAllChildView{
    
    //版面
    UILabel *articleBoardLabel = [[UILabel alloc] init];
    articleBoardLabel.font = BYArticleBoardFont;
    articleBoardLabel.textColor = [UIColor lightGrayColor];
    articleBoardLabel.textAlignment = NSTextAlignmentLeft;
    articleBoardLabel.dk_textColorPicker = DKColor_TEXTCOLOR_TEXT;
    [self addSubview:articleBoardLabel];
    _articleBoardLabel = articleBoardLabel;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = BYBoardArticleTimeFont;
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.dk_textColorPicker = DKColor_TEXTCOLOR_TEXT;
    [self addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = BYBoardArticleTitleFont;
    titleLabel.numberOfLines = 0;
    titleLabel.dk_textColorPicker = DKColor_TEXTCOLOR_TITLE;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIView *spaceView = [UIView spaceView];
    [self addSubview:spaceView];
    _spaceView = spaceView;
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    [self addSubview:arrowView];
    self.arrowView = arrowView;
}

- (void)setCollectionFrame:(BYCollectionFrame *)collectionFrame{
    _collectionFrame = collectionFrame;
    
    //设置数据
    [self setUpData];
    
    //设置frame
    [self setUpFrame];
}

-(void)setUpData{
    //版面
    _articleBoardLabel.text = _collectionFrame.collection.bname;
    
    //标题
    _titleLabel.text = _collectionFrame.collection.title;
    if (!_collectionFrame.collection.user) {
        _titleLabel.textColor = [UIColor grayColor];
    }else{
        _titleLabel.textColor = [UIColor blackColor];
    }
    
    //时间
    NSDate *postTime = [NSDate dateWithTimeIntervalSince1970:[_collectionFrame.collection.createdTime longLongValue]];
    _timeLabel.text = [NSString stringWithFormat:@"于%@收录", [postTime stringFromBYDate]];
}

//设置frame
-(void)setUpFrame{
    //版面
    _articleBoardLabel.frame = _collectionFrame.boardLabelFrame;
    
    //时间
    _timeLabel.frame = _collectionFrame.collectTimeLabelFrame;
    
    //标题
    _titleLabel.frame = _collectionFrame.titleLabelFrame;
    
    _spaceView.frame = _collectionFrame.spaceViewFrame;
    
    _arrowView.frame = _collectionFrame.arrowViewFrame;
}
@end
