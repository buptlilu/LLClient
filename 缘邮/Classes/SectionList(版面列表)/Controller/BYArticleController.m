//
//  BYArticleController.m
//  缘邮
//
//  Created by LiLu on 15/12/5.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYArticleController.h"
#import "BYArticleResult.h"
#import "BYArticleTool.h"
#import "BYArticleFrame.h"
#import "BYArticleCell.h"
#import "BYArticleToolBar.h"
#import "BYCollectionTool.h"
#import "BYAddCollectionParam.h"
#import "BYMeTool.h"
#import "BYMeDetailController.h"
#import "BYBaseParam.h"
#import "BYSendMailController.h"
#import "BYReplyMailController.h"
#import "BYReplyMailParam.h"
#import "BYPlayerToolBar.h"
#import "BYAccountTool.h"
#import "BYAccount.h"
#import "BYSongTimeView.h"
#import "BYSongPlayView.h"
#import "BYMusicPlayingState.h"
#import "BYReplyMsgParam.h"
#import "BYPostArticleBaseController.h"
#import "BYArticleParam.h"

#import "douPlayer.h"
#import "MWZoomingScrollView.h"
#import "MWTapDetectingImageView.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "MWPhotoBrowser.h"
#import "UMSocial.h"
#import "AudioStreamer.h"
#import "UIButton+CZ.h"

@interface BYArticleController ()<UITableViewDataSource, UITableViewDelegate, BYArticleToolBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate, BYArticleCellDelegate, UIActionSheetDelegate, MWPhotoBrowserDelegate, UMSocialUIDelegate, UINavigationControllerDelegate>
//解析后返回的MVVM模型数组
@property (nonatomic, strong) NSMutableArray *articleFrames;

@property (nonatomic, strong) BYArticle *firstArticle;

//解析后返回的MVVM模型数组 精彩回复
@property (nonatomic, strong) NSMutableArray *likeArticleFrames;

//解析后的分页情况
@property (nonatomic, strong) BYPagination *pagination;

@property (nonatomic ,strong) UITableView *tableView;

/**
 *  底部工具栏
 */
@property (nonatomic, strong) BYArticleToolBar *toolBar;

/**
 *  点击MWPhotoBrowser后的图片数组
 */
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

#pragma mark 播放音乐相关的
@property (nonatomic, strong) BYPlayerToolBar *musicToolBar; //保存toolbar
@end

@implementation BYArticleController

#pragma mark - lazy load
- (NSMutableArray *)likeArticleFrames{
    if (!_likeArticleFrames) {
        _likeArticleFrames = [NSMutableArray array];
    }
    return _likeArticleFrames;
}

-(NSMutableArray *)articleFrames{
    if (!_articleFrames) {
        _articleFrames = [NSMutableArray array];
    }
    return _articleFrames;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题字体和颜色
    [self setUpViews];
    
    //进入界面先加载一次
    [self loadArticle];
    
    //添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(loadAriticleForHeaderRefreshing)];
    
    //添加上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(loadAriticleForFooterRefreshing)];
    
    self.toolBar.delegate = self;
    self.toolBar.pageView.delegate = self;
}

#pragma mark - functions
- (void)setUpViews {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dk_backgroundColorPicker = DKColor_BACKGROUND;
    tableView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - kTopBarHeight - kStatusBarHeight);
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    
    BYArticleToolBar *toolBar = [[BYArticleToolBar alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - kTopBarHeight - kStatusBarHeight - kBottomBarHeight, Main_Screen_Width, kBottomBarHeight)];
    [self.view addSubview:toolBar];
    toolBar.backgroundColor = [UIColor lightGrayColor];
    self.toolBar = toolBar;
    
    UIBarButtonItem *shareBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(shareArticle)];
    shareBar.dk_tintColorPicker = DKColor_BACKGROUND_NAVBAR_TINT;
    
    UIBarButtonItem *reportBar = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStylePlain target:self action:@selector(reportArticle)];
    reportBar.dk_tintColorPicker = DKColor_BACKGROUND_NAVBAR_TINT;
    
    self.navigationItem.rightBarButtonItems = @[shareBar, reportBar];
    
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 200, 40)];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.numberOfLines = 0;
    [titleText setText:self.title];
    if (titleText.numberOfLines > 1) {
        [titleText setFont:[UIFont systemFontOfSize:12.0]];
    }else{
        [titleText setFont:[UIFont systemFontOfSize:15]];
    }
    titleText.dk_textColorPicker = DKColorWithRGB(0xFFFFFF, 0x8f969b);
    self.navigationItem.titleView=titleText;
}

//举报按钮
- (void)reportArticle{
    [MBProgressHUD showSuccess:@"举报成功"];
}

//回复文章
- (void)shareArticle{
    if (self.articleFrames.count) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收录该文章", @"分享给朋友", nil];
        [sheet showInView:self.view];
    }
}

//蒙版代理事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        BYAddCollectionParam *param = nil;
//        BYLog(@"收录该文章");
        //设置参数
        param = [BYAddCollectionParam param];
        param.BYid = self.articleParam.BYid;
        param.board = self.articleParam.name;
        [BYCollectionTool addArticleToCollectionWithParam:param whenSuccess:^(BYArticle *article) {
            if (article) {
                [MBProgressHUD showSuccess:@"收录成功"];
            }
        } whenFailure:^(NSError *error) {
            [MBProgressHUD showSuccess:@"已收录"];
        }];
    }
    
    else if (buttonIndex == 1){
//        BYLog(@"分享给朋友");
        if (self.articleFrames.count) {
            NSString *shareUrlStr = [NSString stringWithFormat:@"http://bbs.cloud.icybee.cn/article/%@/%d", self.firstArticle.board_name, self.firstArticle.BYid];
            BYLog(@"shareUrlStr:%@", shareUrlStr);
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrlStr;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrlStr;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.firstArticle.title;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.firstArticle.title;
            NSInteger contentMax = self.firstArticle.content.length;
            contentMax = contentMax < 100 ? contentMax : 100;
            NSString *shareText = [self.firstArticle.content substringWithRange:NSMakeRange(0, contentMax)];
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"56d2dd7767e58e9cfb001350"
                                              shareText:shareText
                                             shareImage:[UIImage imageNamed:@"Icon-256"]
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                               delegate:self];
        }
    }
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


#pragma mark 底部工具栏相关的代理方法
- (void)articleToolBar:(BYArticleToolBar *)toolBar didClickButton:(NSInteger)index{
    if (index == 0) {
        //上一页
        if (self.articleParam.page > 1){
            self.articleParam.page--;
            [self loadPage];
        }else{
            [MBProgressHUD showSuccess:@"已经显示第一页"];
            return;
        }
    }else if (index == 1){
        //下一页
        if (self.articleParam.page < self.pagination.page_all_count) {
            self.articleParam.page++;
            [self loadPage];
        }else{
            [MBProgressHUD showSuccess:@"已经显示最后一页"];
            return;
        }
    }else if (index == 2){
        //跳转
        self.articleParam.page = (int)([self.toolBar.pageView selectedRowInComponent:0] + 1);
        [self loadPage];
    }else if (index == 3){
        //回复
        //创建参数模型
        BYReplyMsgParam *param = [BYReplyMsgParam param];
        param.name = self.firstArticle.board_name;
        param.title = [NSString stringWithFormat:@"Re:%@", self.firstArticle.title];
//        param.content = [NSString stringWithFormat:@"\n\n【 在 %@ 的大作中提到: 】%@", self.firstArticle.user.BYid, self.firstArticle.content];
        param.reid = self.firstArticle.BYid;
        
        BYPostArticleBaseController *replyVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"replyMsg"];
        replyVc.replyParam = param;
        replyVc.title = @"回复文章";
        [self.navigationController pushViewController:replyVc animated:YES];
    }else{
        return;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    CGAffineTransform rotateItem = CGAffineTransformMakeRotation(3.14 / 2);
    rotateItem = CGAffineTransformScale(rotateItem, 1, 1);
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = [NSString stringWithFormat:@"%ld/%d", (long)(row + 1), self.pagination.page_all_count];
    
    label.frame = CGRectMake(0, 0, 100, 100);
    [label setTextAlignment:NSTextAlignmentCenter];
    label.transform = rotateItem;
    UIButton *btn = self.toolBar.btns[0];
    label.textColor = btn.titleLabel.textColor;
    label.font = btn.titleLabel.font;
    
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    BYLog(@"row宽度:%f", self.toolBar.frame.size.width * 0.2);
    return self.toolBar.frame.size.height * 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
//    BYLog(@"row高度:%f", self.toolBar.frame.size.height * 1);
    return self.toolBar.frame.size.width * 0.2;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pagination.page_all_count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld", (long)row];
}



//进入界面先刷新一次
-(void)loadArticle{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    //加载数据
    [BYArticleTool loadArticleWithArticleParam:self.articleParam whenSuccess:^(BYArticleResult *articleResult) {
        [self.articleFrames removeAllObjects];
        [self.likeArticleFrames removeAllObjects];
        
        //拿到数据赋值给模型
        for (BYArticle *article in articleResult.article) {
            BYArticleFrame *articleFrame = [[BYArticleFrame alloc] init];
            articleFrame.article = article;
            [self.articleFrames addObject:articleFrame];
        }
        
        //设置标题
        if (self.articleFrames.count) {
            UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
            BYArticleFrame *first = self.articleFrames[0];
            self.firstArticle = first.article;
            titleLabel.text = first.article.title;
            
            if (titleLabel.numberOfLines > 1) {
                [titleLabel setFont:[UIFont systemFontOfSize:12.0]];
            }else{
                [titleLabel setFont:[UIFont systemFontOfSize:15]];
            }
        }
   
        
        //拿到精彩回复数据赋值给模型
        if (articleResult.like_articles.count) {
            for (BYArticle *like_article in articleResult.like_articles) {
                BYArticleFrame *likeAF = [[BYArticleFrame alloc] init];
                likeAF.article = like_article;
                [self.likeArticleFrames addObject:likeAF];
            }
            NSSortDescriptor *des = [[NSSortDescriptor alloc] initWithKey:@"article.like_sum" ascending:NO];
            self.likeArticleFrames = [(NSMutableArray *)[self.likeArticleFrames sortedArrayUsingDescriptors:@[des]] mutableCopy];
        }
    

        //分页数据
        self.pagination = articleResult.pagination;
        
        //刷新tableView
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        //更新总页数
        [self.toolBar.pageView reloadAllComponents];
        [self.toolBar.pageView selectRow:0 inComponent:0 animated:YES];
        
//        BYLog(@"tableView:%@", NSStringFromCGRect(self.tableView.frame));
        [self.tableView reloadData];
    } whenfailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败"];
        BYLog(@"%@", error);
    }];
}

//头部，下拉刷新
-(void)loadAriticleForHeaderRefreshing{
    if (self.articleParam.page > 1){
        self.articleParam.page--;
    }else{
        self.articleParam.page = 1;
    }

    //加载数据
    [BYArticleTool loadArticleWithArticleParam:self.articleParam whenSuccess:^(BYArticleResult *articleResult) {
        [self.tableView headerEndRefreshing];
        
        //清空缓存
        [self.articleFrames removeAllObjects];
        [self.likeArticleFrames removeAllObjects];
        
        //拿到数据赋值给模型
        for (BYArticle *article in articleResult.article) {
            BYArticleFrame *articleFrame = [[BYArticleFrame alloc] init];
            articleFrame.article = article;
            [self.articleFrames addObject:articleFrame];
        }
        
        //拿到精彩回复数据赋值给模型
        //拿到精彩回复数据赋值给模型
        if (articleResult.like_articles.count) {
            for (BYArticle *like_article in articleResult.like_articles) {
                BYArticleFrame *likeAF = [[BYArticleFrame alloc] init];
                likeAF.article = like_article;
                [self.likeArticleFrames addObject:likeAF];
            }
            NSSortDescriptor *des = [[NSSortDescriptor alloc] initWithKey:@"article.like_sum" ascending:NO];
            self.likeArticleFrames = [(NSMutableArray *)[self.likeArticleFrames sortedArrayUsingDescriptors:@[des]] mutableCopy];
        }
        
        //分页数据
        self.pagination = articleResult.pagination;
        
        [self.toolBar.pageView reloadAllComponents];
        [self.toolBar.pageView selectRow:self.pagination.page_current_count - 1 inComponent:0 animated:YES];
        
        //刷新tableView
        [MBProgressHUD showSuccess:@"加载成功"];
        [self.tableView reloadData];
    } whenfailure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [MBProgressHUD showError:@"加载失败"];
        BYLog(@"%@", error);
    }];
}

//尾部，上拉刷新
-(void)loadAriticleForFooterRefreshing{
    if (self.articleParam.page < self.pagination.page_all_count) {
        //请求下一页的数据
        self.articleParam.page++;
        
        //加载数据
        [BYArticleTool loadArticleWithArticleParam:self.articleParam whenSuccess:^(BYArticleResult *articleResult) {
            [self.tableView footerEndRefreshing];
            
            //拿到评论数据赋值给模型
            [self.articleFrames removeAllObjects];
            [self.likeArticleFrames removeAllObjects];
            
            for (BYArticle *article in articleResult.article) {
                BYArticleFrame *articleFrame = [[BYArticleFrame alloc] init];
                articleFrame.article = article;
                [self.articleFrames addObject:articleFrame];
            }
            
            //分页数据
            self.pagination = articleResult.pagination;
            
            //刷新tableView
            [MBProgressHUD showSuccess:@"加载成功"];
            
            [self.toolBar.pageView reloadAllComponents];
            [self.toolBar.pageView selectRow:self.pagination.page_current_count - 1 inComponent:0 animated:YES];
            
            [self.tableView reloadData];
            //显示到第一行
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        } whenfailure:^(NSError *error) {
            [self.tableView footerEndRefreshing];
            [MBProgressHUD showError:@"加载失败"];
            BYLog(@"%@", error);
        }];
    }else{
        [self.tableView footerEndRefreshing];
        [MBProgressHUD showSuccess:@"已显示全部"];
    }
}

//翻页
- (void)loadPage{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //加载数据
    [BYArticleTool loadArticleWithArticleParam:self.articleParam whenSuccess:^(BYArticleResult *articleResult) {
        //拿到数据赋值给模型
        [self.articleFrames removeAllObjects];
        [self.likeArticleFrames removeAllObjects];
        
        for (BYArticle *article in articleResult.article) {
            BYArticleFrame *articleFrame = [[BYArticleFrame alloc] init];
            articleFrame.article = article;
            [self.articleFrames addObject:articleFrame];
        }
        
        //拿到精彩回复数据赋值给模型
        if (articleResult.like_articles.count) {
            for (BYArticle *like_article in articleResult.like_articles) {
                BYArticleFrame *likeAF = [[BYArticleFrame alloc] init];
                likeAF.article = like_article;
                [self.likeArticleFrames addObject:likeAF];
            }
            NSSortDescriptor *des = [[NSSortDescriptor alloc] initWithKey:@"article.like_sum" ascending:NO];
            self.likeArticleFrames = [(NSMutableArray *)[self.likeArticleFrames sortedArrayUsingDescriptors:@[des]] mutableCopy];
        }
        
        //分页数据
        self.pagination = articleResult.pagination;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.toolBar.pageView reloadAllComponents];
        [self.toolBar.pageView selectRow:self.pagination.page_current_count - 1 inComponent:0 animated:YES];
        [self.tableView reloadData];
        
        //显示到第一行
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    } whenfailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        BYLog(@"%@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.likeArticleFrames.count) {
        //有精彩回复 分为3个显示
        return 3;
    }else{
        //没有精彩回复,看是否是首页
        if (self.pagination.page_current_count == 1) {
            //首页,2个
            return 2;
        }else{
            //其他页,1个
            return 1;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.likeArticleFrames.count) {
        //有精彩回复
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return self.likeArticleFrames.count;
        }else if (section == 2){
            return self.articleFrames.count - 1;
        }else{
            return 0;
        }
    }else{
        //没有精彩回复,看是否是首页
        if (self.pagination.page_current_count == 1) {
            if (section == 0) {
                //首页, 楼主
                return 1;
            }else{
                //首页, 全部回复
                return self.articleFrames.count - 1;
            }
        }else{
            //其他页, 全部回复
            return self.articleFrames.count;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYArticleCell *cell = [BYArticleCell cellWithTableView:tableView];
    
    //取出模型
    BYArticleFrame *articleFrame = [[BYArticleFrame alloc] init];
    if (self.likeArticleFrames.count) {
        if (indexPath.section == 0) {
            articleFrame = self.articleFrames[0];
        }else if (indexPath.section == 1){
            articleFrame = self.likeArticleFrames[indexPath.row];
        }else if (indexPath.section == 2){
            articleFrame = self.articleFrames[indexPath.row + 1];
        }else{
            articleFrame = nil;
        }
    }else{
        //没有精彩回复,看是否是首页
        if (self.pagination.page_current_count == 1) {
            if (indexPath.section == 0) {
                //首页, 楼主
                articleFrame = self.articleFrames[indexPath.row];
            }else{
                //首页, 全部回复
                articleFrame = self.articleFrames[indexPath.row + 1];
            }
        }else{
            //其他页, 全部回复
            articleFrame = self.articleFrames[indexPath.row];
        }
    }
    cell.articleFrame = articleFrame;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    
    //如果有音乐附件且在播放,更新播放条状态
    if ([BYMusicPlayingState shareMusicPlayingState].isPlaying) {
        NSString *currentCellId = [NSString stringWithFormat:@"%@%@", articleFrame.article.user.BYid, articleFrame.article.post_time];
        if ([[BYMusicPlayingState shareMusicPlayingState].userId isEqualToString:currentCellId]) {
            //更新状态
            if (cell.toolBars.count > 0 && [BYMusicPlayingState shareMusicPlayingState].index > 0) {
                [[BYMusicPlayingState shareMusicPlayingState].player startTimer];
                BYPlayerToolBar *toolBar = cell.toolBars[[BYMusicPlayingState shareMusicPlayingState].index - 1];
                toolBar.playView.playBtn.selected = [BYMusicPlayingState shareMusicPlayingState].isPlaying;
                [toolBar.playView.playBtn setNBg:@"playbar_pausebtn_click" hBg:@"playbar_pausebtn_normal"];
                [toolBar.timeView.timeSlider addTarget:self action:@selector(timeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                toolBar.timeView.timeSlider.value = [BYMusicPlayingState shareMusicPlayingState].currentTime / [BYMusicPlayingState shareMusicPlayingState].totalTime;
                toolBar.timeView.currentTimeLabel.text = [BYMusicPlayingState shareMusicPlayingState].totalTimeText;
                toolBar.timeView.totalTimeLabel.text = [BYMusicPlayingState shareMusicPlayingState].currentTimeText;
                self.musicToolBar = toolBar;
                [self playerControl];
            }
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat viewH = [self tableView:tableView heightForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYScreenW, viewH)];
    view.dk_backgroundColorPicker = DKColor_BACKGROUND;
    
    //用户楼层
    NSString *text = @"";
    if (self.likeArticleFrames.count) {
        if (section == 0) {
            text = @"楼主";
        }else if (section == 1){
            text = @"精彩回复";
        }else if (section == 2){
            text = @"全部回复";
        }else{
            text = nil;
        }
    }else {
        if (self.pagination.page_current_count == 1) {
            if (section == 0) {
                text = @"楼主";
            }else{
                text = @"全部回复";
            }
        }else{
            text = @"全部回复";
        }
    }
    
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = BYTableViewTitleFont;
    CGSize titleSize = [text sizeWithAttributes:titleAttr];
    
    CGFloat labelX = BYBoardArticleMargin;
    CGFloat labelY = (viewH - titleSize.height) * 0.5;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, titleSize.width, titleSize.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blueColor];
    titleLabel.font = BYTableViewTitleFont;
    titleLabel.text = text;
    
    CGFloat devideX = CGRectGetMaxX(titleLabel.frame) + BYBoardArticleMargin;
    CGFloat devideY = viewH * 0.5;
    CGFloat devideW = BYScreenW - devideX;
    CGFloat devideH = 1;
    
    UIView *devide = [[UIView alloc] initWithFrame:CGRectMake(devideX, devideY, devideW, devideH)];
    devide.backgroundColor = [UIColor lightGrayColor];
    
    [view addSubview:titleLabel];
    [view addSubview:devide];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出模型
    BYArticleFrame *articleFrame = [[BYArticleFrame alloc] init];
    if (self.likeArticleFrames.count) {
        //有精彩回复
        if (indexPath.section == 0) {
            articleFrame = self.articleFrames[0];
        }else if (indexPath.section == 1){
            articleFrame = self.likeArticleFrames[indexPath.row];
        }else if (indexPath.section == 2){
            articleFrame = self.articleFrames[indexPath.row + 1];
        }else{
            articleFrame = nil;
        }
    }else{
        //没有精彩回复,看是否是首页
        if (self.pagination.page_current_count == 1) {
            if (indexPath.section == 0) {
                //首页, 楼主
                articleFrame = self.articleFrames[indexPath.row];
            }else{
                //首页, 全部回复
                articleFrame = self.articleFrames[indexPath.row + 1];
            }
        }else{
            //其他页, 全部回复
            articleFrame = self.articleFrames[indexPath.row];
        }
    }
    
    return articleFrame.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kBottomBarHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark cell代理方法
- (void)cellItemsDidClick:(NSInteger)index article:(BYArticle *)article{
    if (index == 0) {
        if (!article.user.BYid) {
            return;
        }
        BYSendMailController *sendMailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sendMail"];
        sendMailVc.sendUserId = article.user.BYid;
        [self.navigationController pushViewController:sendMailVc animated:YES];
    }else if (index == 1){
        //创建参数模型
        BYReplyMsgParam *param = [BYReplyMsgParam param];
        param.name = self.firstArticle.board_name;
        param.title = [NSString stringWithFormat:@"Re:%@", self.firstArticle.title];
        param.content = [NSString stringWithFormat:@"\n @%@\n\n【 在 %@ 的大作中提到: 】%@", article.user.BYid, self.firstArticle.user.BYid, self.firstArticle.content];
        param.reid = self.firstArticle.BYid;
        
        BYPostArticleBaseController *replyVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"replyMsg"];
        replyVc.replyParam = param;
        replyVc.title = @"回复文章";
        [self.navigationController pushViewController:replyVc animated:YES];
        
//        BYReplyMsgParam *param = [BYReplyMsgParam param];
//        param.name = article.board_name;
//        param.title = [NSString stringWithFormat:@"Re:%@", article.title];
//        param.content = [NSString stringWithFormat:@"\n@%@\n\n【 在 %@ 的大作中提到: 】%@", article.user.BYid ,article.user.BYid, article.content];
//        param.reid = article.BYid;
//        
//        BYPostArticleBaseController *replyVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"replyMsg"];
//        replyVc.replyParam = param;
//        replyVc.title = @"回复文章";
//        [self.navigationController pushViewController:replyVc animated:YES];
//        BYLog(@"@");
    }else if (index == 2){
        //创建参数模型
        BYReplyMsgParam *param = [BYReplyMsgParam param];
        param.name = article.board_name;
        param.title = [NSString stringWithFormat:@"Re:%@", article.title];
        param.content = [NSString stringWithFormat:@"\n\n【 在 %@ 的大作中提到: 】%@", article.user.BYid, article.content];
        param.reid = article.BYid;
        
        BYPostArticleBaseController *replyVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"replyMsg"];
        replyVc.replyParam = param;
        replyVc.title = @"回复文章";
        [self.navigationController pushViewController:replyVc animated:YES];
//        BYLog(@"回复");
    }else{
        return;
    }
}

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
        }else{
            [MBProgressHUD showError:@"该用户已不存在"];
        }
        
    } whenFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"该用户已不存在"];
        BYLog(@"%@", error);
    }];
}

//点击了图片
- (void)cellDidClickImage:(NSInteger)index attachment:(BYAttachment *)attachment cell:(BYArticleCell *)cell{
    NSArray *files = attachment.file;
    NSMutableArray *photos = [NSMutableArray array];
    NSMutableArray *thumbs = [NSMutableArray array];
    MWPhoto *photo, *thumb;
    BYBaseParam *param = [BYBaseParam param];
    NSString *urlStrPhoto, *urlStrThumb;
    
    for (BYFile *file in files) {
        //设置图片url
        urlStrPhoto = [NSString stringWithFormat:@"%@?oauth_token=%@", file.url, param.oauth_token];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:urlStrPhoto]];
        [photos addObject:photo];
        
        urlStrThumb = [NSString stringWithFormat:@"%@?oauth_token=%@", file.thumbnail_middle, param.oauth_token];
        thumb = [MWPhoto photoWithURL:[NSURL URLWithString:urlStrThumb]];
        [thumbs addObject:thumb];
    }
    
    self.photos = photos;
    self.thumbs = thumbs;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    if (index - 1 < 0 || index > photos.count) {
        index = 1;
    }
    [browser viewDidLoad];
    [browser setCurrentPhotoIndex:index - 1];
    UIImageView *imgView = cell.articleFrame.imgViews[index - 1];
    self.imgView = imgView;
    CGRect imgViewRect = [self.view convertRect:imgView.frame fromView:imgView.superview];
    self.imgViewFrame = imgViewRect;

    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - 播放音乐
- (void)cellDidClickToolBar:(BYPlayerToolBar *)toolBar article:(BYArticle *)article type:(BtnType)type{
    
    
    [toolBar.timeView.timeSlider addTarget:self action:@selector(timeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.musicToolBar = toolBar;
    [BYMusicPlayingState shareMusicPlayingState].index = toolBar.tag;
    if (type == BtnTypePlay) {
        //播放
        NSArray *files = article.attachment.file;
        //如果保存的正播放的用户ID和当前的不一样,就把url重新设置,如果是同一个,就继续播放
        if (![[BYMusicPlayingState shareMusicPlayingState].userId isEqualToString:[NSString stringWithFormat:@"%@%@", article.user.BYid, article.post_time]]) {
            if (toolBar.tag <= files.count) {
                BYFile *file = files[toolBar.tag - 1];
                NSString *musicUrlStr = [NSString stringWithFormat:@"%@?oauth_token=%@", file.url, [BYAccountTool account].access_token];
                [self createPlayerWithUrlStr:musicUrlStr];
                [BYMusicPlayingState shareMusicPlayingState].userId = [NSString stringWithFormat:@"%@%@", article.user.BYid, article.post_time];
            }
        }
        [[BYMusicPlayingState shareMusicPlayingState].player play];
        [BYMusicPlayingState shareMusicPlayingState].isPlaying = YES;
    }else if (type == BtnTypePause){
        //暂停
        [[BYMusicPlayingState shareMusicPlayingState].player pause];
        //移除定时器
        [BYMusicPlayingState shareMusicPlayingState].isPlaying = NO;
        //恢复头像的位置
        toolBar.playView.singerImgView.transform = CGAffineTransformIdentity;
    }
}

- (void)timeSliderValueChanged:(UISlider *)sender{
    [BYMusicPlayingState shareMusicPlayingState].player.currentTime = sender.value;
}


//根据时间s得到00:00样式时间
- (NSString *)getMinuteSecondWithSecond:(NSTimeInterval)time{
    
    int minute = (int)time / 60;
    int second = (int)time % 60;
    
    if (second > 9) {
        return [NSString stringWithFormat:@"%d:%d",minute,second];
    }
    return [NSString stringWithFormat:@"%d:0%d",minute,second];
}

- (void)createPlayerWithUrlStr:(NSString *)urlStr
{
    [self destroyPlayer];
    
    [BYMusicPlayingState shareMusicPlayingState].player = [[douPlayer alloc] init];
    
    [self playerControl];
    
    [[BYMusicPlayingState shareMusicPlayingState].player stop];
    
    [BYMusicPlayingState shareMusicPlayingState].player.track.audioFileURL = [NSURL URLWithString:urlStr];
}

- (void)playerControl{
    __weak typeof(self) weakSelf = self;
    __weak typeof(douPlayer *) weakDouPLayer = [BYMusicPlayingState shareMusicPlayingState].player;
    
    if ([[BYMusicPlayingState shareMusicPlayingState].player isPlaying]) {
        //正在播放 做事情
        BYLog(@"isPlaying");
    }
    else{
        //停止播放 做事情
        BYLog(@"isPause");
    }
    
    [[BYMusicPlayingState shareMusicPlayingState].player setStatusBlock:^(DOUAudioStreamer *streamer) {
        switch ([streamer status]) {
            case DOUAudioStreamerPlaying:
                //正在播放
                BYLog(@"Playing");
                break;
                
            case DOUAudioStreamerPaused:
                //停止播放
                BYLog(@"Paused");
                break;
                
            case DOUAudioStreamerIdle:
                //空闲
                BYLog(@"Idle");
                [weakDouPLayer stop];
                break;
                
            case DOUAudioStreamerFinished:
                //播放完了
                BYLog(@"Stop");
                [weakDouPLayer stop];
                break;
                
            case DOUAudioStreamerBuffering:
                BYLog(@"Buffering");
                //正在缓存
                break;
                
            case DOUAudioStreamerError:
                //出现错误
                BYLog(@"Error");
                [weakDouPLayer stop];
                break;
        }
    }];
    
    [[BYMusicPlayingState shareMusicPlayingState].player setDurationBlock:^(DOUAudioStreamer *streamer) {
        if ([streamer duration] == 0.0) {
            NSLog(@"当前:%f===总时间:%f", [streamer currentTime] , [streamer duration]);
            [weakSelf.musicToolBar.timeView.timeSlider setValue:0.0f animated:NO];
        }
        else {
            [BYMusicPlayingState shareMusicPlayingState].totalTime = [streamer duration];
            [BYMusicPlayingState shareMusicPlayingState].currentTime = [streamer currentTime];
            [BYMusicPlayingState shareMusicPlayingState].totalTimeText = [self getMinuteSecondWithSecond:[streamer currentTime]];
            [BYMusicPlayingState shareMusicPlayingState].currentTimeText = [self getMinuteSecondWithSecond:[streamer duration]];
            weakSelf.musicToolBar.timeView.totalTimeLabel.text = [self getMinuteSecondWithSecond:[streamer currentTime]];
            weakSelf.musicToolBar.timeView.currentTimeLabel.text = [self getMinuteSecondWithSecond:[streamer duration]];
            weakSelf.musicToolBar.timeView.timeSlider.maximumValue = [streamer duration];
            [weakSelf.musicToolBar.timeView.timeSlider  setValue:[streamer currentTime] animated:YES];
            NSLog(@"当前:%f===总时间:%f", [streamer currentTime] , [streamer duration]);
        }
    }];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[BYMusicPlayingState shareMusicPlayingState].player stopTimer];
}


- (void)destroyPlayer
{
    //停止播放的时候必须做的事情
    if ([BYMusicPlayingState shareMusicPlayingState].player)
    {
        [[BYMusicPlayingState shareMusicPlayingState].player stop];
        [BYMusicPlayingState shareMusicPlayingState].player = nil;
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}
@end

