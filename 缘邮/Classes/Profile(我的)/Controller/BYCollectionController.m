//
//  BYCollectionController.m
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYCollectionController.h"
#import "BYPagination.h"
#import "BYCollectionListResult.h"
#import "BYCollectionListParam.h"
#import "BYCollectionTool.h"
#import "BYCollectionFrame.h"
#import "BYCollectionCell.h"
#import "BYCollection.h"
#import "BYArticleController.h"
#import "BYDeleteCollectionParam.h"
#import "BYArticleParam.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MJExtension.h"

@interface BYCollectionController () <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *articleFrames;

@property (nonatomic, strong) BYPagination *pagination;

@property (nonatomic, strong) BYCollectionListParam *param;

@property (nonatomic, strong) BYCollection *deleteCollection;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BYCollectionController

#pragma mark - lazy load
- (NSMutableArray *)articleFrames{
    if (!_articleFrames) {
        _articleFrames = [NSMutableArray array];
    }
    return _articleFrames;
}

- (BYCollectionListParam *)param{
    if (!_param) {
        _param = [BYCollectionListParam param];
    }
    return _param;
}

- (BYPagination *)pagination{
    if (!_pagination) {
        _pagination = [[BYPagination alloc] init];
    }
    return _pagination;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
   
    //进入界面先加载一次
    [self loadCollection];
    
    //添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(loadCollectionForHeaderRefreshing)];
    
    //添加上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(loadCollectionForFooterRefreshing)];
}

#pragma mark - functions
- (void)setUpViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - kTopBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    tableView.dk_backgroundColorPicker = DKColor_BACKGROUND_Setting;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
}

- (void)editCollection:(UIBarButtonItem *)bar{
    bar.tag = (bar.tag + 1) % 2;
    if (bar.tag == 1) {
        self.tableView.editing = YES;
        bar.title = @"完成";
    }else{
        self.tableView.editing = NO;
        bar.title = @"编辑";
    }
}

//进入界面先刷新一次
-(void)loadCollection{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BYCollectionTool loadArticleFromCollectionWithParam:self.param whenSuccess:^(BYCollectionListResult *articleList) {
        [self.articleFrames removeAllObjects];
        
        //拿到模型数据
        for (BYCollection *collection in articleList.article) {
            BYCollectionFrame *colFrame = [[BYCollectionFrame alloc] init];
            colFrame.collection = collection;
            [self.articleFrames addObject:colFrame];
        }
        
        //拿到分页数据
        self.pagination = articleList.pagination;
        
        //刷新tableView
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败"];
    }];
}

//头部，下拉刷新
-(void)loadCollectionForHeaderRefreshing{
    self.param.page = 1;
    
    [BYCollectionTool loadArticleFromCollectionWithParam:self.param whenSuccess:^(BYCollectionListResult *articleList) {
        
        //停止刷新
        [self.tableView headerEndRefreshing];
        
        [self.articleFrames removeAllObjects];
        
        //拿到模型数据
        for (BYCollection *collection in articleList.article) {
            BYCollectionFrame *colFrame = [[BYCollectionFrame alloc] init];
            colFrame.collection = collection;
            [self.articleFrames addObject:colFrame];
        }
        
        //拿到分页数据
        self.pagination = articleList.pagination;
        
        //刷新tableView
        [MBProgressHUD showSuccess:@"加载成功"];
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [MBProgressHUD showError:@"加载失败"];
    }];
}

//尾部,上拉刷新
-(void)loadCollectionForFooterRefreshing{
    //请求更多数据
    if (self.param.page < self.pagination.page_all_count) {
        self.param.page ++;
        
        [BYCollectionTool loadArticleFromCollectionWithParam:self.param whenSuccess:^(BYCollectionListResult *articleList) {
            
            //停止刷新
            [self.tableView footerEndRefreshing];
            
//            [self.articleFrames removeAllObjects];
            
            //拿到模型数据
            for (BYCollection *collection in articleList.article) {
                BYCollectionFrame *colFrame = [[BYCollectionFrame alloc] init];
                colFrame.collection = collection;
                [self.articleFrames addObject:colFrame];
            }
            
            //拿到分页数据
            self.pagination = articleList.pagination;
            
            //刷新tableView
            [MBProgressHUD showSuccess:@"加载成功"];
            [self.tableView reloadData];
        } whenFailure:^(NSError *error) {
            [self.tableView footerEndRefreshing];
            [MBProgressHUD showError:@"加载失败"];
        }];

        
        
    }else{
        [self.tableView footerEndRefreshing];
        [MBProgressHUD showSuccess:@"已显示全部"];
    }
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
    return self.articleFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYCollectionCell *cell = [BYCollectionCell cellWithTableView:tableView];
    
    //取出模型
    BYCollectionFrame *colFrame = self.articleFrames[indexPath.row];
    
    //cell配置
    cell.collectionFrame = colFrame;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYCollectionFrame *colFrame = self.articleFrames[indexPath.row];
    return colFrame.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取出模型数据
    BYCollectionFrame *colFrame = self.articleFrames[indexPath.row];
    
    if (colFrame.collection.user) {
        //有帖子,打开具体文章
        BYArticleParam *param = [BYArticleParam param];
        param.name = colFrame.collection.bname;
        param.BYid = colFrame.collection.gid;
        
        //创建文章控制器
        BYArticleController *articleVc = [[BYArticleController alloc] init];
        articleVc.articleParam = param;
        articleVc.title = colFrame.collection.title;
        [self.navigationController pushViewController:articleVc animated:YES];
    }else{
        //原帖已删除
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"原帖已不存在,是否从我的收录中移除?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"移除", nil];
        self.deleteCollection = colFrame.collection;
        [sheet showInView:self.view];
    }
}

//删除事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark tableView 删除事件
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        BYLog(@"点击了:%ld", (long)indexPath.row);
        BYCollectionFrame *colFrame = self.articleFrames[indexPath.row];
        self.deleteCollection = colFrame.collection;
        [self deleteArticleFromCollection];
    }];
    return @[deleteRowAction];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //移除
        [self deleteArticleFromCollection];
    }else{
//        BYLog(@"取消");
    }
}

#pragma mark 移除文章
- (void)deleteArticleFromCollection{
    if (self.deleteCollection) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        BYDeleteCollectionParam *param = [BYDeleteCollectionParam param];
        param.BYid = self.deleteCollection.gid;
        [BYCollectionTool deleteArticleFromCollectionWithParam:param whenSuccess:^(BYArticle *article) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"删除成功"];
            [self loadCollectionBack];
        } whenFailure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:@"删除失败"];
        }];
    }
}

-(void)loadCollectionBack{
    [BYCollectionTool loadArticleFromCollectionWithParam:self.param whenSuccess:^(BYCollectionListResult *articleList) {
        //删除缓存
        [self.articleFrames removeAllObjects];
        
        //拿到模型数据
        for (BYCollection *collection in articleList.article) {
            BYCollectionFrame *colFrame = [[BYCollectionFrame alloc] init];
            colFrame.collection = collection;
            [self.articleFrames addObject:colFrame];
        }
        
        //拿到分页数据
        self.pagination = articleList.pagination;
        
        //刷新tableView
        [self.tableView reloadData];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
}

@end
