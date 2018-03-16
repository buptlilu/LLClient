//
//  BYSettingCell.m
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYSettingCell.h"

#import "BYBaseSetting.h"


@interface BYSettingCell ()

//箭头
@property(nonatomic, strong) UIImageView *arrowView;

@property(nonatomic, strong) UIImageView *cheakView;

@property(nonatomic, strong) UISwitch *switchView;

@property(nonatomic, strong) BYBadgeView *badgeView;

@property(nonatomic, strong) UILabel *labelView;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titLabel;
@property (nonatomic, strong) UILabel *subLabel;
@end

@implementation BYSettingCell

#pragma mark - lazy load
-(UILabel *)labelView{
    if (!_labelView) {
        _labelView = [[UILabel alloc] init];
        _labelView.textAlignment = NSTextAlignmentCenter;
        _labelView.textColor =  [UIColor redColor];
    }
    return _labelView;
}

-(UIImageView *)arrowView{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    }
    return _arrowView;
}

-(UIImageView *)cheakView{
    if (_cheakView == nil) {
        _cheakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_checkmark"]];
    }
    return _cheakView;
}

-(UISwitch *)switchView{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titLabel = [UILabel labelWith:[UIFont systemFontOfSize:17] textColor:DKColor_TEXTCOLOR_TITLE textAlignment:NSTextAlignmentLeft];
        [self addSubview:titLabel];
        self.titLabel = titLabel;
        
        UILabel *subLabel = [UILabel labelWith:[UIFont systemFontOfSize:17] textColor:DKColor_TEXTCOLOR_TEXT textAlignment:NSTextAlignmentRight];
        [self addSubview:subLabel];
        self.subLabel = subLabel;
        
        UIImageView *imgView = [UIImageView new];
        [self addSubview:imgView];
        self.imgView = imgView;
        
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
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.equalTo(self).with.offset(16);
        make.centerY.equalTo(self);
    }];
    
    CGSize size = [XUtil sizeWithString:@"我收录的文章  " font:self.titLabel.font maxSize:CGSizeZero];
    [self.titLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.centerY.equalTo(self);
        make.left.mas_equalTo(self.imgView.mas_right).with.offset(16);
    }];
    
    [self.spaceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width, 0.5));
        make.bottom.equalTo(self);
        make.left.equalTo(self.titLabel);
    }];
    
    [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-16);
        make.top.and.bottom.equalTo(self);
        make.left.mas_equalTo(self.titLabel.mas_right).with.offset(16);
    }];
    
    [super updateConstraints];
}
#pragma mark 开关事件
- (void)switchValueChanged:(UISwitch *)sender{
    if ([self.delegate respondsToSelector:@selector(cellSwitchValuedDidChanged:)]) {
        [self.delegate cellSwitchValuedDidChanged:self.switchView];
    }
}


-(BYBadgeView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[BYBadgeView alloc] init];
    }
    return _badgeView;
}

-(void)setItem:(BYSettingItem *)item{
    _item = item;
    
    //设置内容
    [self setUpData];
    
    //设置右边视图
    [self setUpRightView];
    
    //设置label
    if ([_item isKindOfClass:[BYLabelItem class]]) {
        //设置label
        BYLabelItem *labelItem = (BYLabelItem *)_item;
        self.labelView.text = labelItem.text;
        [self addSubview:self.labelView];
    }else{
        //不是就干掉
        [_labelView removeFromSuperview];
    }
}

-(void)setUpData{
    self.titLabel.text = _item.title;
    if (_item.subTitle) {
        self.arrowView.hidden = YES;
        self.subLabel.hidden = NO;
        self.subLabel.text = _item.subTitle;
    }else {
        self.arrowView.hidden = NO;
        self.subLabel.hidden = YES;
    }
    self.detailTextLabel.text = _item.subTitle;
    self.imgView.image = _item.image;
}

-(void)setUpRightView{
    if ([_item isKindOfClass:[BYArrowItem class]]) {//箭头
        self.accessoryView = self.arrowView;
    }else if([_item isKindOfClass:[BYBadgeItem class]]){//badgeView
        BYBadgeItem *badgeItem = (BYBadgeItem *)_item;
        self.badgeView.badgeValue = badgeItem.badgeValue;
        self.accessoryView = self.arrowView;
        [self addSubview:self.badgeView];
    }else if ([_item isKindOfClass:[BYCheakItem class]]){ //打勾
        BYCheakItem *cheakItem = (BYCheakItem *)_item;
        if (cheakItem.cheak) {
            self.accessoryView = self.cheakView;
        }else{
            self.accessoryView = nil;
        }
    }else if ([_item isKindOfClass:[BYSwitchItem class]]){ //开关
        [self.switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.switchView setOn:[[NSUserDefaults standardUserDefaults] boolForKey:BYIsAutoPushNewMsgCountKey]];
        self.accessoryView = self.switchView;
    }else{
        self.accessoryView = nil;
    }
    
    if (![_item isKindOfClass:[BYBadgeItem class]]) {
        self.badgeView.badgeValue = 0;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.labelView.frame = self.bounds;
    self.badgeView.frame = CGRectMake(self.accessoryView.frame.origin.x - 20, (44 - self.badgeView.frame.size.height) * 0.5, self.badgeView.frame.size.width, self.badgeView.frame.size.height);
}
@end
