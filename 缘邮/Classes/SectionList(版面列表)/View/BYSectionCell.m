//
//  BYSectionCell.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYSectionCell.h"
#import "BYSection.h"
#import "DKViewController.h"

@interface BYSectionCell ()

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *spaceView;
@end

@implementation BYSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
        [self addSubview:arrowView];
        self.arrowView = arrowView;
        
        UILabel *label = [UILabel labelWith:[UIFont systemFontOfSize:17] textColor:DKColor_TEXTCOLOR_TITLE textAlignment:NSTextAlignmentLeft];
        [self addSubview:label];
        self.label = label;
        
        UIView *spaceView = [UIView spaceView];
        [self addSubview:spaceView];
        self.spaceView = spaceView;
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
        make.right.equalTo(self.arrowView.mas_left).with.offset(-16);
    }];
    
    [self.spaceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.label);
    }];
    
    [super updateConstraints];
}

-(void)setSection:(BYSection *)section{
    _section = section;
    
    //设置内容
    self.label.text = _section.description;
}
@end
