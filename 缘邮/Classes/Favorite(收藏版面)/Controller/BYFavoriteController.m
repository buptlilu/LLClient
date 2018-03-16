//
//  BYFavoriteController.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYFavoriteController.h"
#import "BYFavoriteTool.h"
#import "BYFavorite.h"
#import "BYBoard.h"
#import "BYBoardCell.h"
#import "BYAddOrDeleteFavoriteParam.h"
#import "BYFavoriteResult.h"
#import "BYBoardArticleController.h"
#import "BYBoardArticleParam.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"

@interface BYFavoriteController ()<BYBoardCellDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>
//模型数组
@property (nonatomic, strong) NSArray *favorites;

/**
 *  记录当前点击收藏的是哪一个cell
 */
@property (nonatomic, strong) BYBoardCell *cell;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BYFavoriteController

#pragma mark - lazy load
- (NSArray *)favorites{
    if (!_favorites) {
        _favorites = [NSArray array];
    }
    return _favorites;
}

#pragma mark - life cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    
    //进入界面先刷新一次
    [self loadFavoriteList];
    
    //添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(loadFavoriteListForHeaderRefreshing)];
}

#pragma mark - functions
- (void)setUpViews {
    [self setUpNavBarTitleView:@"收藏"];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dk_backgroundColorPicker = DKColor_BACKGROUND;
    tableView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - kTopBarHeight - kStatusBarHeight);
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
}

//下拉刷新
- (void)loadFavoriteListForHeaderRefreshing{
    [BYFavoriteTool loadFavoriteListForRefreshing:YES whenSuccess:^(NSArray *favorites) {
        //停止刷新
        [self.tableView headerEndRefreshing];
        //获取数据
        self.favorites = favorites;
        
        //刷新表格
        [MBProgressHUD showSuccess:@"加载成功"];
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        //停止刷新
        [self.tableView headerEndRefreshing];
        [MBProgressHUD showError:@"加载失败"];
        BYLog(@"%@", error);
    }];
}

//加载收藏版面数据
-(void)loadFavoriteList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BYFavoriteTool loadFavoriteListForRefreshing:NO whenSuccess:^(NSArray *favorites) {
        //获取数据
        self.favorites = favorites;
        
        //刷新表格
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败"];
        BYLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favorites.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYBoardCell *cell = [BYBoardCell cellWithTableView:tableView];
    cell.board = self.favorites[indexPath.row];
    cell.delegate = self;
    //这里是收藏夹板块,所以所有的cell都是高亮星星状态
    cell.btn.selected = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //打开文章的控制器
    BYBoardArticleController *boardArticleVc = [[BYBoardArticleController alloc] init];
    //打开文章的控制器需要传递一个参数过去
    BYBoardArticleParam *boardArticleParam = [BYBoardArticleParam param];
    
    //打开文章的控制器这里需要去除cell对应的board，把name属性传递给boardArticleParam
    BYBoard *board = self.favorites[indexPath.row];
    
    //打开帖子列表
    boardArticleParam.name = board.name;
    boardArticleVc.title = board.BYdescription;
    boardArticleVc.boardArticleParam = boardArticleParam;
    
    //push控制器时隐藏tabbar
    boardArticleVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:boardArticleVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kBottomBarHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark cell代理事件
- (void)addOrDeleteFavorite:(BYBoardCell *)cell{
    if (cell.btn.selected) {
        self.cell = cell;
        //取消收藏
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"将%@版面从收藏夹移除?", cell.board.BYdescription] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消收藏", nil];
        [sheet showInView:self.view];
    }
}

//蒙版代理事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    BYLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 0) {
        if (self.cell.btn.selected) {
            //设置参数
            BYAddOrDeleteFavoriteParam *param = [BYAddOrDeleteFavoriteParam param];
            param.name = self.cell.board.name;
            
            //取消收藏
            [BYFavoriteTool deleteFavoriteBoardWithParam:param whenSuccess:^(BYFavoriteResult *favoriteResult) {
                self.favorites = favoriteResult.board;
                [self.tableView reloadData];
                [MBProgressHUD showSuccess:@"取消收藏成功"];
            } whenFailure:^(NSError *error) {
                [MBProgressHUD showError:@"取消收藏失败"];
            }];
        }
    }
}


@end
