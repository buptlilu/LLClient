//
//  BYBoardController.m
//  缘邮
//
//  Created by LiLu on 15/12/4.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYBoardController.h"
#import "BYBoardCell.h"
#import "BYBoardTool.h"
#import "BYBoardResult.h"
#import "BYBoardParam.h"
#import "BYBoard.h"
#import "BYBoardArticleController.h"
#import "BYBoardArticleParam.h"
#import "BYAddOrDeleteFavoriteParam.h"
#import "BYFavoriteResult.h"
#import "BYFavoriteTool.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MJExtension.h"

@interface BYBoardController () <BYBoardCellDelegate, UIActionSheetDelegate,UITableViewDelegate, UITableViewDataSource>
/**
 *  存储BYBoard数组
 */
@property(nonatomic, strong) NSMutableArray *boards;
@property(nonatomic, strong) NSMutableArray *sub_sections;
@property(nonatomic, strong) NSMutableArray *subSectionBoardResults;

//收藏夹
@property(nonatomic, strong) NSArray *favorites;

/**
 *  记录分区数据是否都拿到了
 */
@property(nonatomic, assign) NSInteger recordSubSectionLoaded;

/**
 *  记录当前点击收藏的是哪一个cell
 */
@property(nonatomic, strong) BYBoardCell *cell;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BYBoardController

#pragma mark - lazy load
-(NSArray *)favorites{
    if (!_favorites) {
        _favorites = [NSArray array];
    }
    return _favorites;
}

-(NSMutableArray *)subSectionBoardResults{
    if (!_subSectionBoardResults) {
        _subSectionBoardResults = [NSMutableArray array];
    }
    return _subSectionBoardResults;
}

-(NSMutableArray *)sub_sections{
    if (!_sub_sections) {
        _sub_sections = [NSMutableArray array];
    }
    return _sub_sections;
}

-(NSMutableArray *)boards{
    if (!_boards) {
        _boards = [NSMutableArray array];
    }
    return _boards;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    
    //进入界面先刷新一次刷新
    [self loadBoardList];
    
    //添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadBoardListForHeaderRefreshing)];
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
}

-(void)loadBoardListForHeaderRefreshing{
    [BYFavoriteTool loadFavoriteListForRefreshing:YES whenSuccess:^(NSArray *favorites) {
        //停止刷新
        [self.tableView headerEndRefreshing];
        //获取数据
        self.favorites = favorites;
        
        //得到收藏夹数据之后,再去更新版面列表
        [BYBoardTool loadBoardListWithBoardParam:self.boardParam whenSuccess:^(BYBoardResult *boardResult) {
            [self.tableView headerEndRefreshing];
            self.sub_sections = boardResult.sub_section;
            self.boards = boardResult.board;
            if (self.sub_sections.count) {
                //如果在分区里还有分区的话
                
                //情况数组，重新加载
                [self.subSectionBoardResults removeAllObjects];
                self.recordSubSectionLoaded = 0;
                
                for (NSString *subSectionName in self.sub_sections) {
                    //请求分区数据
                    BYBoardParam *boardParam = [BYBoardParam param];
                    boardParam.name = subSectionName;
                    [BYBoardTool loadBoardListWithBoardParam:boardParam whenSuccess:^(BYBoardResult *boardResult) {
                        [self.subSectionBoardResults addObject:boardResult];
                        NSLog(@"%lu", (unsigned long)self.subSectionBoardResults.count);
                        self.recordSubSectionLoaded++;
                        if (self.recordSubSectionLoaded == self.sub_sections.count) {
                            //刷新界面
                            [MBProgressHUD showSuccess:@"加载成功"];
                            [self.tableView reloadData];
                        }
                    } whenfailure:^(NSError *error) {
                        [MBProgressHUD showSuccess:@"加载失败"];
                        BYLog(@"分区请求错误:%@", error);
                    }];
                }
            }else{
                //刷新界面
                [MBProgressHUD showSuccess:@"加载成功"];
                [self.tableView reloadData];
            }
        } whenfailure:^(NSError *error) {
            [self.tableView headerEndRefreshing];
            [MBProgressHUD showError:@"加载失败"];
            BYLog(@"版面请求错误:%@", error);
        }];
        
    } whenFailure:^(NSError *error) {
        //停止刷新
        [self.tableView headerEndRefreshing];
        [MBProgressHUD showError:@"加载失败"];
        BYLog(@"%@", error);
    }];
}

-(void)loadBoardList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.boards.count) {
        [BYFavoriteTool loadFavoriteListForRefreshing:YES whenSuccess:^(NSArray *favorites) {
            //获取数据
            self.favorites = favorites;
            
            //刷新表格
            [self.tableView reloadData];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } whenFailure:^(NSError *error) {
            //停止刷新
            [MBProgressHUD showError:@"加载失败"];
            BYLog(@"%@", error);
        }];
        return;
    }
    
    [self.subSectionBoardResults removeAllObjects];
    
    [BYFavoriteTool loadFavoriteListForRefreshing:YES whenSuccess:^(NSArray *favorites) {
        //获取数据
        self.favorites = favorites;
        
        //得到收藏夹数据之后,再去更新版面列表
        [BYBoardTool loadBoardListWithBoardParam:self.boardParam whenSuccess:^(BYBoardResult *boardResult) {
            self.sub_sections = boardResult.sub_section;
            self.boards = boardResult.board;
            if (self.sub_sections.count) {
                
                //如果在分区里还有分区的话
                
                //情况数组，重新加载
                [self.subSectionBoardResults removeAllObjects];
                self.recordSubSectionLoaded = 0;
                
                for (NSString *subSectionName in self.sub_sections) {
                    //请求分区数据
                    BYBoardParam *boardParam = [BYBoardParam param];
                    boardParam.name = subSectionName;
                    [BYBoardTool loadBoardListWithBoardParam:boardParam whenSuccess:^(BYBoardResult *boardResult) {
                        [self.subSectionBoardResults addObject:boardResult];
                        self.recordSubSectionLoaded++;
                        if (self.recordSubSectionLoaded == self.sub_sections.count) {
                            //刷新界面
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            [self.tableView reloadData];
                        }
                    } whenfailure:^(NSError *error) {
                        //刷新界面
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [MBProgressHUD showError:@"加载失败"];
                        BYLog(@"分区请求错误:%@", error);
                    }];
                }
            }else{
                //刷新界面
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.tableView reloadData];
            }
        } whenfailure:^(NSError *error) {
            //刷新界面
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:@"加载失败"];
            BYLog(@"版面请求错误:%@", error);
        }];

        
    } whenFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败"];
        BYLog(@"%@", error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.subSectionBoardResults) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.subSectionBoardResults) {
        switch (section) {
            case 0:
                return self.subSectionBoardResults.count;
                break;
            case 1:
                return self.boards.count;
                break;
            default:
                return 1;
                break;
        }
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYBoardCell *cell = [BYBoardCell cellWithTableView:tableView];
    if (self.subSectionBoardResults) {
        //有分区列表
        switch (indexPath.section) {
            case 0:
                //还可以进入的分区列表
                cell.boardResult = self.subSectionBoardResults[indexPath.row];
                break;
            case 1:
                //不能进入的最终列表
                cell.board = self.boards[indexPath.row];
                cell.delegate = self;
                
                //防止cell重用,先置为NO
                cell.btn.selected = NO;
                //如果当前的板块是收藏板块就把星星变成高亮的
                for (BYFavorite *favorite in self.favorites) {
                    if ([cell.board.name isEqualToString:favorite.name]) {
                        cell.btn.selected = YES;
                        break;
                    }
                }
                
                break;
        
            default:
                break;
        }
    }else{
        //没有可以进入的分区列表
        cell.board = self.boards[indexPath.row];
        cell.delegate = self;
        
        //防止cell重用,先置为NO
        cell.btn.selected = NO;
        //如果当前的板块是收藏板块就把星星变成高亮的
        for (BYFavorite *favorite in self.favorites) {
            if ([cell.board.name isEqualToString:favorite.name]) {
                cell.btn.selected = YES;
                break;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //打开文章的控制器
    BYBoardArticleController *boardArticleVc = [[BYBoardArticleController alloc] init];
    //打开文章的控制器需要传递一个参数过去
    BYBoardArticleParam *boardArticleParam = [BYBoardArticleParam param];
    
    //打开分区的控制器
    BYBoardController *boardVc = [[BYBoardController alloc] init];
    //如果要打开分区的话，把param中的name传过去
    NSString *boardParamName = @"";
    //如果要打开分区的话，需要传递一个参数
    BYBoardParam *boardParam = [BYBoardParam param];
    
    //打开文章的控制器这里需要去除cell对应的board，把name属性传递给boardArticleParam
    BYBoard *board = [[BYBoard alloc] init];
    
    if (self.sub_sections.count) {
        //打开分区控制器需要传递参数过去，这不用下载了，因为这一步已经下好了。
        BYBoardResult *boardResult = [[BYBoardResult alloc] init];
        switch (indexPath.section) {
            case 0:
                //进入二级分区
                boardResult = self.subSectionBoardResults[indexPath.row];
                boardParamName = self.sub_sections[indexPath.row];
                boardParam.name = boardParamName;
                boardVc.boards = boardResult.board;
                boardVc.title = boardResult.BYdescription;
                boardVc.boardParam = boardParam;
                [self.navigationController pushViewController:boardVc animated:YES];
                break;
            case 1:
                //打开帖子列表
                board = self.boards[indexPath.row];
                boardArticleParam.name = board.name;
                boardArticleVc.title = board.BYdescription;
                boardArticleVc.boardArticleParam = boardArticleParam;
                [self.navigationController pushViewController:boardArticleVc animated:YES];
            default:
                break;
        }
    }else{
        //打开帖子列表
        board = self.boards[indexPath.row];
        boardArticleParam.name = board.name;
        boardArticleVc.title = board.BYdescription;
        boardArticleVc.boardArticleParam = boardArticleParam;
        [self.navigationController pushViewController:boardArticleVc animated:YES];
    }
}

#pragma mark cell代理事件
- (void)addOrDeleteFavorite:(BYBoardCell *)cell{
    UIActionSheet *sheet = nil;
    self.cell = cell;
    if (cell.btn.selected) {
        //取消收藏
        sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"将%@版面从收藏夹移除?", cell.board.BYdescription] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消收藏", nil];
    }else{
        //添加收藏
        sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"将%@版面加入收藏夹?", cell.board.BYdescription] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加收藏", nil];
    }
    [sheet showInView:self.view];
}

//蒙版代理事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    BYLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 0) {
        //设置参数
        BYAddOrDeleteFavoriteParam *param = [BYAddOrDeleteFavoriteParam param];
        param.name = self.cell.board.name;
        
        if (self.cell.btn.selected) {
            //取消收藏
            [BYFavoriteTool deleteFavoriteBoardWithParam:param whenSuccess:^(BYFavoriteResult *favoriteResult) {
                [MBProgressHUD showSuccess:@"取消收藏成功"];
                self.cell.btn.selected = !self.cell.btn.selected;
            } whenFailure:^(NSError *error) {
                [MBProgressHUD showError:@"取消收藏失败"];
            }];
        }else{
            //添加收藏
            [BYFavoriteTool addFavoriteBoardWithParam:param whenSuccess:^(BYFavoriteResult *favoriteResult) {
                [MBProgressHUD showSuccess:@"添加收藏成功"];
                self.cell.btn.selected = !self.cell.btn.selected;
            } whenFailure:^(NSError *error) {
                [MBProgressHUD showError:@"添加收藏失败"];
            }];
        }
    }
}
@end
