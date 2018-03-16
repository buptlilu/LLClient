//
//  BYMsgDetailController.m
//  缘邮
//
//  Created by LiLu on 16/2/29.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYMsgDetailController.h"
#import "BYArticleFrame.h"
#import "BYArticleCell.h"
#import "BYArticle.h"
#import "BYMeTool.h"
#import "BYSendMailController.h"
#import "BYMeDetailController.h"
#import "BYArticleParam.h"
#import "BYArticleController.h"
#import "BYReplyMsgParam.h"
#import "BYPostArticleBaseController.h"

#import "MBProgressHUD+MJ.h"


@interface BYMsgDetailController () <UITableViewDataSource, UITableViewDelegate, BYArticleCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//阅读文章
- (IBAction)readArticleClick:(UIButton *)sender;
//回复消息
- (IBAction)replyMessageClick:(UIBarButtonItem *)sender;

@end

@implementation BYMsgDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYArticleCell *cell = [BYArticleCell cellWithTableView:tableView];
    BYArticleFrame *articleFrame = self.articleFrame;
    articleFrame.article.position = -1;
    cell.articleFrame = articleFrame;
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.articleFrame.cellHeight;
}

#pragma mark cell代理事件
//点击了链接
- (void)cellDidClickUrl:(NSString *)urlStr{
    //打开浏览器
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

//点击了用户
- (void)cellDidclickUser:(NSString *)userId{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BYMeTool loadUserInfoWithUserId:userId whenSuccess:^(BYMeResult *userInfo) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (userInfo != nil) {
            //进入个人信息控制器展示
            BYMeDetailController *meDetailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MeDetail"];
            meDetailVc.meInfo = userInfo;
            meDetailVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:meDetailVc animated:YES];
        }
        
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
}


#pragma mark 点击事件
//同主题展开
- (IBAction)readArticleClick:(UIButton *)sender {
    //创建参数模型
    BYArticleParam *articleParam = [BYArticleParam param];
    articleParam.name = self.articleFrame.article.board_name;
    NSLog(@"%@", articleParam.name);
    articleParam.BYid = (int)self.articleFrame.article.group_id;
    
    //创建文章控制器
    BYArticleController *articleVc = [[BYArticleController alloc] init];
    articleVc.articleParam = articleParam;
    [self.navigationController pushViewController:articleVc animated:YES];
}

//回复消息
- (IBAction)replyMessageClick:(UIBarButtonItem *)sender {
    //创建参数模型
    BYReplyMsgParam *param = [BYReplyMsgParam param];
    param.name = self.articleFrame.article.board_name;
    param.title = [NSString stringWithFormat:@"Re:%@", self.articleFrame.article.title];
    param.content = [NSString stringWithFormat:@"\n【 在 %@ 的大作中提到: 】%@", self.articleFrame.article.user.BYid, self.articleFrame.article.content];
    param.reid = self.articleFrame.article.BYid;
    
    BYPostArticleBaseController *replyVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"replyMsg"];
    replyVc.replyParam = param;
    replyVc.title = @"回复文章";
    [self.navigationController pushViewController:replyVc animated:YES];
}
@end
