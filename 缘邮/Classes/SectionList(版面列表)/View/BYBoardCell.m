//
//  BYBoardCell.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoardCell.h"
#import "BYBoard.h"
#import "BYBoardResult.h"

@interface BYBoardCell ()
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *spaceView;
@end

@implementation BYBoardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"stariPhoneSpootlight7_40pt"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"starHighiPhoneSpootlight7_40pt"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.btn = btn;
        
        UILabel *label = [UILabel labelWith:[UIFont systemFontOfSize:17] textColor:DKColor_TEXTCOLOR_TITLE textAlignment:NSTextAlignmentLeft];
        [self addSubview:label];
        self.label = label;
        
        UIView *spaceView = [UIView spaceView];
        [self addSubview:spaceView];
        self.spaceView = spaceView;
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
        [self addSubview:arrowView];
        self.arrowView = arrowView;
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.right.mas_equalTo(self).with.offset(-16);
        make.centerY.equalTo(self);
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(16);
        make.right.equalTo(self).with.offset(-70);
    }];
    
    [self.spaceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.label);
    }];
    
    [self.btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.mas_equalTo(self).with.offset(-16);
        make.centerY.equalTo(self);
    }];
    
    [super updateConstraints];
}

-(void)setBoard:(BYBoard *)board{
    _board = board;
    self.label.text = self.board.BYdescription;
    self.btn.hidden = NO;
    self.arrowView.hidden = YES;
    //若不设置frame btn就显示不出来
    self.btn.frame = CGRectMake(0, 0, 44, 44);
}

-(void)setBoardResult:(BYBoardResult *)boardResult{
    _boardResult = boardResult;
    self.label.text = self.boardResult.BYdescription;
    self.btn.hidden = YES;
    self.arrowView.hidden = NO;
}

//处理收藏事件
- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(addOrDeleteFavorite:)]) {
        [self.delegate addOrDeleteFavorite:self];
    }
}
@end
