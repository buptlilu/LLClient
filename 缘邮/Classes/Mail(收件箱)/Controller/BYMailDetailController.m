//
//  BYMailDetailController.m
//  缘邮
//
//  Created by LiLu on 16/2/19.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMailDetailController.h"
#import "BYMailTool.h"
#import "BYMailDetailParam.h"
#import "BYMail.h"
#import "BYUser.h"
#import "BYReplyMailController.h"
#import "BYReplyMailParam.h"

#import "YYText.h"
#import "YYLabel.h"
#import "YYImage.h"
#import "UIImage+YYWebImage.h"
#import "UIView+YYAdd.h"
#import "NSBundle+YYAdd.h"
#import "NSString+YYAdd.h"
#import "BYTextTool.h"
#import "BYSimpleTextParser.h"

#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "NSDate+MJ.h"

@interface BYMailDetailController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//显示mail的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mailContentViewHeight;

/**
 *  邮件标题
 */
@property (weak, nonatomic) IBOutlet UILabel *mailTitleLabel;

/**
 *  发件人头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *mailSendUserIconImgView;

/**
 *  发件人ID
 */
@property (weak, nonatomic) IBOutlet UILabel *mailSendUserNameLabel;

/**
 *  发件时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mailSendTimeLabel;

/**
 *  邮件内容
 */
@property (weak, nonatomic) IBOutlet YYLabel *mailContentLabel;

/**
 *  邮件具体内容
 */
@property (nonatomic, strong) BYMail *mailDetail;

@end

@implementation BYMailDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置右边写邮件的按钮
    [self setUpRightBarButtonItem];
    
    //进入界面加载邮件信息
    [self loadMailDetail];
}

#pragma mark 写邮件事件处理
- (void)setUpRightBarButtonItem{
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(writeMail)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
}

- (void)writeMail{
//    BYLog(@"回复邮件");
    //进入邮件具体信息界面
    BYReplyMailController *replyMailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"replyMail"];
    
    //设置回复邮件需要的参数
    BYReplyMailParam *param = [BYReplyMailParam param];
    param.BYid = self.mailDetail.user.BYid;
    param.box = self.param.box;
    param.num = self.mailDetail.index;
    param.title = [NSString stringWithFormat:@"Re:%@", self.mailDetail.title];
    param.content = [NSString stringWithFormat:@"\n【 在 %@ 的大作中提到: 】%@", self.mailDetail.user.BYid, self.mailDetail.content];
    
    replyMailVc.param = param;
    
    [self.navigationController pushViewController:replyMailVc animated:YES];
}

- (void)loadMailDetail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BYMailTool loadMailDetailWithParam:self.param whenSuccess:^(BYMail *mailDetail) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.mailDetail = mailDetail;
    } whenFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"获取信件失败"];
    }];
}

//给界面各个参数设置内容
- (void)setMailDetail:(BYMail *)mailDetail{
    _mailDetail = mailDetail;
    
    //标题
    self.mailTitleLabel.text = self.mailDetail.title;
    
    //头像
    [self.mailSendUserIconImgView sd_setImageWithURL:[NSURL URLWithString:self.mailDetail.user.face_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //昵称
    self.mailSendUserNameLabel.text = self.mailDetail.user.user_name;
    
    if ([self.mailDetail.user.gender isEqualToString:@"m"]) {
        self.mailSendUserNameLabel.textColor = BYMaleNameColor;
    }else if ([self.mailDetail.user.gender isEqualToString:@"f"]){
        self.mailSendUserNameLabel.textColor = BYFemaleNameColor;
    }else if([self.mailDetail.user.gender isEqualToString:@"n"]){
        self.mailSendUserNameLabel.textColor = BYUnknownSexNameColor;
    }else{
        self.mailSendUserNameLabel.textColor = BYUnknownSexNameColor;
    }
    
    //发信时间
    NSDate *postTime = [NSDate dateWithTimeIntervalSince1970:[self.mailDetail.post_time longLongValue]];
    self.mailSendTimeLabel.text = [postTime stringFromBYDateAllSameFormatter];
    
    //内容
    NSMutableAttributedString *content = [NSMutableAttributedString new];
    //添加文件
    [content appendAttributedString:[[NSAttributedString alloc] initWithString:self.mailDetail.content attributes:nil]];
    content.yy_font = BYMailContentFont;
    self.mailContentLabel.textParser = (id)[[BYSimpleTextParser alloc] init];
    self.mailContentLabel.numberOfLines = 0;
    self.mailContentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.mailContentLabel.attributedText = content;
    
    //文本布局计算
    CGSize size = CGSizeMake(self.view.bounds.size.width - 10, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:self.mailContentLabel.attributedText];
//    BYLog(@"位置:%@\n大小:%@", NSStringFromCGRect(layout.textBoundingRect), NSStringFromCGSize(layout.textBoundingSize));
    
    //重新给contentView高度赋值
    self.mailContentViewHeight.constant = layout.textBoundingSize.height + self.mailContentLabel.frame.origin.y + 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
