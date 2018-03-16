//
//  BYBoardArticleController.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoardArticleController.h"
#import "BYBoardArticleCell.h"
#import "BYBoardArticleResult.h"
#import "BYBoardArticleTool.h"
#import "BYBoardArticleResult.h"
#import "BYArticle.h"
#import "BYBoardArticleFrame.h"
#import "BYArticleController.h"
#import "BYArticleParam.h"
#import "BYPostArticleParam.h"
#import "BYPostArticleBaseController.h"
#import "BYSearchArticleParam.h"
#import "BYSearchArticleResult.h"
#import "BYBoardArticleParam.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "UIBarButtonItem+Item.h"

@interface BYBoardArticleController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *boardArticleFrames;
@property (nonatomic, strong) BYPagination *pagination;

@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BYBoardArticleController

#pragma mark - lazy load
- (BYPagination *)pagination{
    if (!_pagination) {
        _pagination = [[BYPagination alloc] init];
    }
    return _pagination;
}

- (NSMutableArray *)boardArticleFrames{
    if (!_boardArticleFrames) {
        _boardArticleFrames = [NSMutableArray array];
    }
    return _boardArticleFrames;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.isSearching = YES;
    [self searchArticle];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isSearching = YES;
    [self searchArticle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    
    //进入界面先加载一次
    [self loadBoardArticle];
    
    //添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(loadBoardAriticleForHeaderRefreshing)];
    
    //添加上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(loadBoardAriticleForFooterRefreshing)];
}

#pragma mark - functions
- (void)setUpViews {
    [self setUpNavBarTitleView:self.title];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dk_backgroundColorPicker = DKColor_BACKGROUND;
    tableView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - kTopBarHeight - kStatusBarHeight);
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeArticle)];
    bar.dk_tintColorPicker = DKColor_BACKGROUND_NAVBAR_TINT;
    
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchArticle)];
    bar2.dk_tintColorPicker = DKColor_BACKGROUND_NAVBAR_TINT;
    self.navigationItem.rightBarButtonItems = @[bar, bar2];
}

/**
 *  搜索文章
 */
- (void)searchArticle{
    self.isSearching = !self.isSearching;
    if (self.isSearching) {
        CGFloat h = 80;
        CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame) - h;
        CGFloat x = 0;
        CGFloat w = self.view.width;
        UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        textView.backgroundColor = [UIColor lightGrayColor];
        
        CGFloat textField1X = BYBoardArticleMargin;
        CGFloat textField1Y = 5;
        CGFloat textField1W = self.view.width - 2 * textField1X;
        CGFloat textField1H = h - 2 * textField1Y - 40;
        UITextField *textField1 = [[UITextField alloc] initWithFrame:CGRectMake(textField1X, textField1Y, textField1W, textField1H)];
        textField1.returnKeyType = UIReturnKeySearch;
        textField1.borderStyle = UITextBorderStyleRoundedRect;
        textField1.placeholder = @"请输入主题关键字";
        textField1.backgroundColor = [UIColor whiteColor];
        textField1.delegate = self;
        UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_discover"]];
        textField1.leftViewMode = UITextFieldViewModeAlways;
        textField1.font = [UIFont systemFontOfSize:16];
        textField1.leftView = imageView1;
        textField1.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField1.clearButtonMode = UITextFieldViewModeAlways;
        textField1.keyboardAppearance = UIKeyboardTypeNamePhonePad;
        [textView addSubview:textField1];
        [self.navigationController.view insertSubview:textView belowSubview:self.navigationController.navigationBar];
        
        CGFloat textField2Y = 5 + 40;
        UITextField *textField2 = [[UITextField alloc] initWithFrame:CGRectMake(textField1X, textField2Y, textField1W, textField1H)];
        textField2.returnKeyType = UIReturnKeySearch;
        textField2.borderStyle = UITextBorderStyleRoundedRect;
        textField2.placeholder = @"请输入作者ID";
        textField2.backgroundColor = [UIColor whiteColor];
        textField2.delegate = self;
        UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_discover"]];
        textField2.leftViewMode = UITextFieldViewModeAlways;
        textField2.font = [UIFont systemFontOfSize:16];
        textField2.leftView = imageView2;
        textField2.clearButtonMode = UITextFieldViewModeAlways;
        textField2.keyboardAppearance = UIKeyboardTypeNamePhonePad;
        textField2.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [textView addSubview:textField2];
        [self.navigationController.view insertSubview:textView belowSubview:self.navigationController.navigationBar];
        
        //动画往下面平移
        self.textView = textView;
        self.textField1 = textField1;
        self.textField2 = textField2;
        [UIView animateWithDuration:0.25 animations:^{
            textView.transform = CGAffineTransformMakeTranslation(0, h);
        }];
    }else{
        [self.textField1 resignFirstResponder];
        [self.textField2 resignFirstResponder];
        [UIView animateWithDuration:0.25 animations:^{
            self.textView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self.textField1 removeFromSuperview];
            [self.textField2 removeFromSuperview];
            [self.textView removeFromSuperview];
            
            self.textField1 = nil;
            self.textField2 = nil;
            self.textView = nil;
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BYSearchArticleParam *param = [BYSearchArticleParam param];
    param.board = self.boardArticleParam.name;
    param.title1 = self.textField1.text;
    param.author = self.textField2.text;
    [BYBoardArticleTool searchArticleWithArticleParam:param whenSuccess:^(BYSearchArticleResult *articleResult) {
        
        [self.boardArticleFrames removeAllObjects];
        
        for (BYArticle *article in articleResult.threads) {
            BYBoardArticleFrame *boardArticleFrame = [[BYBoardArticleFrame alloc] init];
            boardArticleFrame.article = article;
            [self.boardArticleFrames addObject:boardArticleFrame];
        }
        //刷新tableView
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
    } whenfailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"查询失败"];
        BYLog(@"%@", error);
    }];
    self.isSearching = YES;
    [self searchArticle];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isSearching = YES;
    [self searchArticle];
}


/**
 *  发表文章
 */
- (void)writeArticle{
    //创建参数模型
    BYPostArticleParam *param = [BYPostArticleParam param];
    param.name = self.boardArticleParam.name;
    param.title = @"";
    param.content = @"";
    
    BYPostArticleBaseController *replyVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"replyMsg"];
    replyVc.postParam = param;
    replyVc.title = @"发表文章";
    [self.navigationController pushViewController:replyVc animated:YES];
}



//头部，下拉刷新
-(void)loadBoardAriticleForHeaderRefreshing{
    self.boardArticleParam.page = 1;
    [BYBoardArticleTool loadBoardArticleWithBoardArticleParam:self.boardArticleParam whenSuccess:^(BYBoardArticleResult *boardArticleResult) {
        //停止刷新
        [self.tableView headerEndRefreshing];
        [self.boardArticleFrames removeAllObjects];
        
        //拿到数据赋值给模型
        for (BYArticle *article in boardArticleResult.article) {
            BYBoardArticleFrame *boardArticleFrame = [[BYBoardArticleFrame alloc] init];
            boardArticleFrame.article = article;
            [self.boardArticleFrames addObject:boardArticleFrame];
        }
        
        //拿到分页模型
        self.pagination = boardArticleResult.pagination;
        
        //刷新tableView
        [MBProgressHUD showSuccess:@"加载成功"];
        [self.tableView reloadData];
    } whenfailure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        BYLog(@"%@", error);
        [MBProgressHUD showError:@"加载失败"];
    }];
}

//尾部,上拉刷新
-(void)loadBoardAriticleForFooterRefreshing{
    //请求更多数据，
    if (self.boardArticleParam.page < self.pagination.page_all_count) {
        self.boardArticleParam.page++;
        [BYBoardArticleTool loadBoardArticleWithBoardArticleParam:self.boardArticleParam whenSuccess:^(BYBoardArticleResult *boardArticleResult) {
            //停止刷新
            [self.tableView footerEndRefreshing];
            
            //拿到数据赋值给模型
            for (BYArticle *article in boardArticleResult.article) {
                BYBoardArticleFrame *boardArticleFrame = [[BYBoardArticleFrame alloc] init];
                boardArticleFrame.article = article;
                [self.boardArticleFrames addObject:boardArticleFrame];
            }
            
            //拿到分页模型
            self.pagination = boardArticleResult.pagination;
            
            //刷新tableView
            [MBProgressHUD showSuccess:@"加载成功"];
            [self.tableView reloadData];
        } whenfailure:^(NSError *error) {
            [self.tableView footerEndRefreshing];
            BYLog(@"%@", error);
            [MBProgressHUD showError:@"加载失败"];
        }];
    }else{
        [self.tableView footerEndRefreshing];
        [MBProgressHUD showSuccess:@"已显示全部"];
    }
}

//进入界面先刷新一次
-(void)loadBoardArticle{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BYBoardArticleTool loadBoardArticleWithBoardArticleParam:self.boardArticleParam whenSuccess:^(BYBoardArticleResult *boardArticleResult) {
        //拿到数据赋值给模型
        for (BYArticle *article in boardArticleResult.article) {
            BYBoardArticleFrame *boardArticleFrame = [[BYBoardArticleFrame alloc] init];
            boardArticleFrame.article = article;
            [self.boardArticleFrames addObject:boardArticleFrame];
        }
        
        //拿到分页模型
        self.pagination = boardArticleResult.pagination;
        
        //刷新tableView
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
    } whenfailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败"];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.boardArticleFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYBoardArticleCell *cell = [BYBoardArticleCell cellWithTableView:tableView];
    
    //取出模型
    BYBoardArticleFrame *boardArticleFrame = self.boardArticleFrames[indexPath.row];
    
    //cell配置
    cell.boardArticleFrame = boardArticleFrame;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYBoardArticleFrame *boardArticleFrame = self.boardArticleFrames[indexPath.row];
    return boardArticleFrame.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取出模型数据
    BYBoardArticleFrame *boardArticleFrame = self.boardArticleFrames[indexPath.row];
    
    //创建参数模型
    BYArticleParam *articleParam = [BYArticleParam param];
    articleParam.name = boardArticleFrame.article.board_name;
//    NSLog(@"%@", articleParam.name);
    articleParam.BYid = boardArticleFrame.article.BYid;
    
    //创建文章控制器
    BYArticleController *articleVc = [[BYArticleController alloc] init];
    articleVc.articleParam = articleParam;
    articleVc.title = boardArticleFrame.article.title;
    [self.navigationController pushViewController:articleVc animated:YES];
}



@end
