//
//  BYArticleCell.m
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYArticleCell.h"
#import "BYArticle.h"
#import "BYUserView.h"
#import "BYArticleFrame.h"
#import "BYAttachment.h"
#import "BYUserMusic.h"
#import "BYPlayerToolBar.h"
#import "BYSongPlayView.h"
#import "BYSongTimeView.h"
#import "BYMusicPlayingState.h"

#import "YYText.h"
#import "UIButton+CZ.h"

@interface BYArticleCell () <BYUserViewDelegate>
//头像区域
@property(nonatomic, weak) BYUserView *userView;

@end

@implementation BYArticleCell

- (NSMutableArray *)toolBars{
    if (!_toolBars) {
        _toolBars = [NSMutableArray array];
    }
    return _toolBars;
}

//注意：cell是用initWithStyle初始化，重写这个方法即可
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加所有子控件
        [self setUpAllChildView];
    }
    return self;
}

-(void)setUpAllChildView{
    //用户信息
    BYUserView *userView = [[BYUserView alloc] init];
    userView.delegate = self;
    [self addSubview:userView];
    _userView = userView;
}

#pragma mark userView代理
//回复/点赞/@ 按钮代理
- (void)replyItemsDidClick:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(cellItemsDidClick:article:)]) {
        [self.delegate cellItemsDidClick:index article:_articleFrame.article];
    }
}

//打开链接代理
- (void)contentViewDidClickLink:(NSString *)urlStr{
    if ([self.delegate respondsToSelector:@selector(cellDidClickUrl:)]) {
        [self.delegate cellDidClickUrl:urlStr];
    }
}

//点击了某人ID
- (void)contentViewDidClickUserId:(NSString *)userId{
    if ([self.delegate respondsToSelector:@selector(cellDidclickUser:)]) {
        [self.delegate cellDidclickUser:userId];
    }
}

//点击了图片
- (void)contentViewDidClickImage:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(cellDidClickImage:attachment:cell:)]) {
        [self.delegate cellDidClickImage:index attachment:_articleFrame.article.attachment cell:self];
    }
}

//点击了音乐
- (void)contentViewDidClickMusic:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(cellDidClickImage:attachment:cell:)]) {
        [self.delegate cellDidClickImage:index attachment:_articleFrame.article.attachment cell:self];
    }
}

/*
 问题：1.cell的高度应该提前计算出来
 2.cell的高度必须要先计算出每个子控件的frame，才能确定
 3.如果在cell的setStatus方法计算子控件的位置，会比较耗性能
 
 解决：MVVM思想
 M:模型
 V:视图
 VM:视图模型(模型包装视图模型，模型+模型对应视图的frame)
 */
-(void)setArticleFrame:(BYArticleFrame *)articleFrame{
    _articleFrame = articleFrame;
    
    //设置用户信息的frame
    _userView.frame = articleFrame.userViewFrame;
    _userView.articleFrame = articleFrame;
    
    //取出music
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", articleFrame.article.user.BYid, articleFrame.article.post_time]];
    if (array.count) {
        [self.toolBars removeAllObjects];
        for (NSData *data in array) {
            BYUserMusic *userMusic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//            BYLog(@"打印解码结果:\nindex:%ld\nlocation:%ld", (long)userMusic.index, (long)userMusic.location);
            NSAttributedString *text = _userView.articleContentView.textLayout.text;
            YYTextAttachment *attr = [text yy_attribute:YYTextAttachmentAttributeName atIndex:userMusic.location];
            BYPlayerToolBar *toolBar = (BYPlayerToolBar *)attr.content;
//            [toolBar.playView.playBtn setTitle:@"哈哈" forState:UIControlStateNormal];
            [toolBar.playView.playBtn addTarget:self action:@selector(contentViewDidClickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
//            BYLog(@"解码class---%@", [attr.content class]);
            [self.toolBars addObject:toolBar];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"%@%@", articleFrame.article.user.BYid, articleFrame.article.post_time]];
}

#pragma mark 点击了toolbar
- (void)contentViewDidClickPlayBtn:(UIButton *)btn{
    BYPlayerToolBar *toolBar = (BYPlayerToolBar *)btn.superview.superview;
    
    //更改播放状态
    btn.selected = !btn.selected;
    
    //判断按钮播放的状态,更改图片
    if (btn.selected) { //播放音乐
        NSLog(@"播放音乐");
        //1.如果是播放的状态,按钮的图片更改为停止的状态
        [btn setNBg:@"playbar_pausebtn_click" hBg:@"playbar_pausebtn_normal"];
        if ([self.delegate respondsToSelector:@selector(cellDidClickToolBar:article:type:)]) {
            [self.delegate cellDidClickToolBar:toolBar article:self.articleFrame.article type:BtnTypePlay];
        }
    }else{
        NSLog(@"暂停");
        //2.如果当前是停止的状态,更改为播放的状态
        [btn setNBg:@"playbar_playbtn_click" hBg:@"playbar_playbtn_normal"];
        if ([self.delegate respondsToSelector:@selector(cellDidClickToolBar:article:type:)]) {
            [self.delegate cellDidClickToolBar:toolBar article:self.articleFrame.article type:BtnTypePause];
        }
    }
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
