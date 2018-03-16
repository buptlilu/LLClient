//
//  BYBoardListController.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYSectionController.h"
#import "BYAccount.h"
#import "BYAccountTool.h"
#import "BYSection.h"
#import "BYHttpTool.h"
#import "BYSectionTool.h"
#import "BYSectionCell.h"
#import "BYBoardController.h"
#import "BYBoardParam.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"


@interface BYSectionController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BYSectionController

#pragma mark - lazy load
- (NSArray *)sections{
    if (!_sections) {
        _sections = [NSArray array];
    }
    return _sections;
}

#pragma mark - life cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    
    //进入界面先加载一次
    [self loadSectionList];
    
    //添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadSectionListForHeaderRefreshing)];
}

#pragma mark - functions
- (void)setUpViews {
//    [DKNightVersionManager nightFalling];
    [self setUpNavBarTitleView:@"版面"];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dk_backgroundColorPicker = DKColor_BACKGROUND;
    tableView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - kTopBarHeight - kStatusBarHeight);
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
}

//加载版面列表数据
-(void)loadSectionListForHeaderRefreshing{
    [BYSectionTool loadSectionListForRefreshing:YES whenSuccess:^(NSArray *sections) {
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        
        self.sections = sections;
        
        [MBProgressHUD showSuccess:@"加载成功"];
        
        //刷新表格
        [self.tableView reloadData];
    } whenfailure:^(NSError *error) {
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        [MBProgressHUD showError:@"加载失败"];
        BYLog(@"%@", error);
    }];
}

//加载版面列表数据
-(void)loadSectionList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BYSectionTool loadSectionListForRefreshing:NO whenSuccess:^(NSArray *sections) {
        self.sections = sections;
        //刷新表格
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
    } whenfailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败"];
        BYLog(@"%@", error);
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYSectionCell *cell = [BYSectionCell cellWithTableView:tableView];
    
    //获取版面列表模型
    BYSection *section = self.sections[indexPath.row];
    
    cell.section = section;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark 点击某一行cell的时候做事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取出当前点击行的模型
    BYSection *section = self.sections[indexPath.row];
    BYBoardParam *boardParam = [BYBoardParam param];
    boardParam.name = section.name;
    
    BYBoardController *boardVc = [[BYBoardController alloc] init];
    boardVc.title = section.description;
    boardVc.boardParam = boardParam;
    
    //push控制器时隐藏tabbar
    boardVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:boardVc animated:YES];
}
@end
