//
//  BYMeInfoCell.m
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMeInfoCell.h"
#import "BYMeResult.h"
#import "BYMeInfoFrame.h"

#import "UIImageView+WebCache.h"

#define IconMargin 10

@interface BYMeInfoCell ()

@property (nonatomic, weak) UIImageView *icon;

@property (nonatomic, weak) UILabel *userId;

@property (nonatomic, weak) UILabel *userName;

@property (nonatomic, weak) UIImageView *arrowView;

@end

@implementation BYMeInfoCell

//注意：cell是用initWithStyle初始化，重写这个方法即可
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加所有子控件
        [self setUpAllChildView];
    }
    return self;
}

-(void)setUpAllChildView{
    //用户头像
    UIImageView *icon = [[UIImageView alloc] init];
    CGFloat iconWH = 50;
    icon.frame = CGRectMake(IconMargin, IconMargin, iconWH, iconWH);
    [self addSubview:icon];
    _icon = icon;
    
    //用户昵称
    UILabel *userName = [[UILabel alloc] init];
    userName.font = BYMeInfoUserNameFont;
    userName.numberOfLines = 1;
    CGFloat nameX = CGRectGetMaxX(icon.frame) + IconMargin;
    CGFloat nameY = IconMargin;
    NSMutableDictionary *nameAttr = [NSMutableDictionary dictionary];
    nameAttr[NSFontAttributeName] = BYMeInfoUserNameFont;
    CGSize nameSize = [@"【意涵团】offer快到碗里来！" sizeWithAttributes:nameAttr];
    CGFloat nameW = BYScreenW - nameX - IconMargin;
    userName.frame = CGRectMake(nameX, nameY, nameW, nameSize.height);
    [self addSubview:userName];
    _userName = userName;
    
    //用户id
    UILabel *userId = [[UILabel alloc] init];
    userId.font = BYMeInfoUserIdFont;
    userId.numberOfLines = 1;
    CGFloat idX = CGRectGetMaxX(icon.frame) + IconMargin;
    CGFloat idY = CGRectGetMaxY(userName.frame) + IconMargin;
    CGFloat idW = nameW;
    NSMutableDictionary *idAttr = [NSMutableDictionary dictionary];
    idAttr[NSFontAttributeName] = BYMeInfoUserIdFont;
    CGSize idSize = [@"论坛ID:lilu" sizeWithAttributes:idAttr];
    userId.frame = CGRectMake(idX, idY, idW, idSize.height);
    [self addSubview:userId];
    _userId = userId;
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    arrowView.frame = CGRectMake(Main_Screen_Width - 16 - 12, (70 - 12) * 0.5, 12, 12);
    [self addSubview:arrowView];
    self.arrowView = arrowView;
}

- (void)setMeInfoFrame:(BYMeInfoFrame *)meInfoFrame{
    _meInfoFrame = meInfoFrame;
    
    //设置内容
    [self setUpData];
    
    //设置frame
//    [self setUpFrame];
}

- (void)setUpData{
    //头像
    [_icon sd_setImageWithURL:[NSURL URLWithString:_meInfoFrame.meInfo.face_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //名字
    _userName.text = _meInfoFrame.userName;
    
    if ([_meInfoFrame.meInfo.gender isEqualToString:@"m"]) {
        _userName.textColor = BYMaleNameColor;
    }else if ([_meInfoFrame.meInfo.gender isEqualToString:@"f"]){
        _userName.textColor = BYFemaleNameColor;
    }else if([_meInfoFrame.meInfo.gender isEqualToString:@"n"]){
        _userName.textColor = BYUnknownSexNameColor;
    }else{
        _userName.textColor = BYUnknownSexNameColor;
    }
    
    //id
    _userId.text = _meInfoFrame.userId;
}

- (void)setUpFrame{
    _icon.frame = _meInfoFrame.userIconViewFrame;
    
    _userName.frame = _meInfoFrame.userNameLabelFrame;
    
    _userId.frame = _meInfoFrame.userIdLabelFrame;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
