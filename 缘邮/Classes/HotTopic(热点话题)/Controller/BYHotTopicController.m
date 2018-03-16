//
//  BYHotTopicController.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYHotTopicController.h"
#import "BYHotTopicTool.h"
#import "BYArticle.h"
#import "BYAttachment.h"
#import "BYUser.h"
#import "BYFile.h"
#import "BYArticle.h"
#import "BYHotTopicCell.h"
#import "BYHotTopicFrame.h"
#import "BYArticleParam.h"
#import "BYArticleController.h"
#import "BYHotTopicResult.h"
#import "BYSectionHotParam.h"
#import "BYBoardArticleController.h"

#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"

@interface BYHotTopicController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *hotTopicFrames;
@property(nonatomic, strong) NSMutableArray *section1Frames;
@property(nonatomic, strong) NSMutableArray *section2Frames;
@property(nonatomic, strong) NSMutableArray *section3Frames;
@property(nonatomic, strong) NSMutableArray *section4Frames;
@property(nonatomic, strong) NSMutableArray *section5Frames;
@property(nonatomic, strong) NSMutableArray *section6Frames;
@property(nonatomic, strong) NSMutableArray *section7Frames;
@property(nonatomic, strong) NSMutableArray *section8Frames;
@property(nonatomic, strong) NSMutableArray *section9Frames;
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation BYHotTopicController

#pragma mark - life cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    
    //进入界面刷新数据
    [self loadHotTopic];
    
    //添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadHotTopicForHeaderRefreshing)];
    
    //设置刷新时显示的文字
    [self.tableView setHeaderRefreshingText:@"玩命加载中..."];
}

#pragma mark - functions
- (void)setUpViews {
    [self setUpNavBarTitleView:@"热点"];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dk_backgroundColorPicker = DKColor_BACKGROUND;
    tableView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - kTopBarHeight - kStatusBarHeight);
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
}

-(void)loadHotTopicForHeaderRefreshing{
    //得到十大数据
    [BYHotTopicTool loadHotTopicWhenSuccess:^(BYHotTopicResult *hotTopicResult) {
        [self.tableView headerEndRefreshing];
        [self.hotTopicFrames removeAllObjects];
        
        //拿到数据赋值给模型
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in hotTopicResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.hotTopicFrames = array;
        
        //刷新tableView
        [MBProgressHUD showSuccess:@"加载成功"];
        [self.tableView reloadData];
    } whenfailure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [MBProgressHUD showError:@"加载失败"];
    }];

    
    //北邮校园
    BYSectionHotParam *section1Param = [BYSectionHotParam param];
    section1Param.name = @"1";
    [BYHotTopicTool loadSectionTopicWithParam:section1Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in favoriteResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.section1Frames = array;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //学术科技
    BYSectionHotParam *section2Param = [BYSectionHotParam param];
    section2Param.name = @"2";
    [BYHotTopicTool loadSectionTopicWithParam:section2Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in favoriteResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.section2Frames = array;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //信息社会
    BYSectionHotParam *section3Param = [BYSectionHotParam param];
    section3Param.name = @"3";
    [BYHotTopicTool loadSectionTopicWithParam:section3Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in favoriteResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.section3Frames = array;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //人文艺术
    BYSectionHotParam *section4Param = [BYSectionHotParam param];
    section4Param.name = @"4";
    [BYHotTopicTool loadSectionTopicWithParam:section4Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in favoriteResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.section4Frames = array;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //生活时尚
    BYSectionHotParam *section5Param = [BYSectionHotParam param];
    section5Param.name = @"5";
    [BYHotTopicTool loadSectionTopicWithParam:section5Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in favoriteResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.section5Frames = array;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationNone];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //休闲娱乐
    BYSectionHotParam *section6Param = [BYSectionHotParam param];
    section6Param.name = @"6";
    [BYHotTopicTool loadSectionTopicWithParam:section6Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in favoriteResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.section6Frames = array;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:6] withRowAnimation:UITableViewRowAnimationNone];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //体育健身
    BYSectionHotParam *section7Param = [BYSectionHotParam param];
    section7Param.name = @"7";
    [BYHotTopicTool loadSectionTopicWithParam:section7Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in favoriteResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.section7Frames = array;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:7] withRowAnimation:UITableViewRowAnimationNone];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //游戏对战
    BYSectionHotParam *section8Param = [BYSectionHotParam param];
    section8Param.name = @"8";
    [BYHotTopicTool loadSectionTopicWithParam:section8Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in favoriteResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.section8Frames = array;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:8] withRowAnimation:UITableViewRowAnimationNone];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];
    
    //乡亲乡爱
    BYSectionHotParam *section9Param = [BYSectionHotParam param];
    section9Param.name = @"9";
    [BYHotTopicTool loadSectionTopicWithParam:section9Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in favoriteResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.section9Frames = array;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:9] withRowAnimation:UITableViewRowAnimationNone];
    } whenFailure:^(NSError *error) {
        BYLog(@"%@", error);
    }];

}

-(void)loadHotTopic{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    //得到十大数据
    [BYHotTopicTool loadHotTopicWhenSuccess:^(BYHotTopicResult *hotTopicResult) {
        //拿到数据赋值给模型
        NSMutableArray *array = [NSMutableArray array];
        for (BYArticle *article in hotTopicResult.article) {
            BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
            hotTopicFrame.article = article;
            [array addObject:hotTopicFrame];
        }
        self.hotTopicFrames = array;

        //刷新tableView
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        //北邮校园
        BYSectionHotParam *section1Param = [BYSectionHotParam param];
        section1Param.name = @"1";
        [BYHotTopicTool loadSectionTopicWithParam:section1Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
            NSMutableArray *array = [NSMutableArray array];
            for (BYArticle *article in favoriteResult.article) {
                BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
                hotTopicFrame.article = article;
                [array addObject:hotTopicFrame];
            }
            self.section1Frames = array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        } whenFailure:^(NSError *error) {
            BYLog(@"%@", error);
        }];
        
        //学术科技
        BYSectionHotParam *section2Param = [BYSectionHotParam param];
        section2Param.name = @"2";
        [BYHotTopicTool loadSectionTopicWithParam:section2Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
            NSMutableArray *array = [NSMutableArray array];
            for (BYArticle *article in favoriteResult.article) {
                BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
                hotTopicFrame.article = article;
                [array addObject:hotTopicFrame];
            }
            self.section2Frames = array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        } whenFailure:^(NSError *error) {
            BYLog(@"%@", error);
        }];
        
        //信息社会
        BYSectionHotParam *section3Param = [BYSectionHotParam param];
        section3Param.name = @"3";
        [BYHotTopicTool loadSectionTopicWithParam:section3Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
            NSMutableArray *array = [NSMutableArray array];
            for (BYArticle *article in favoriteResult.article) {
                BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
                hotTopicFrame.article = article;
                [array addObject:hotTopicFrame];
            }
            self.section3Frames = array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        } whenFailure:^(NSError *error) {
            BYLog(@"%@", error);
        }];
        
        //人文艺术
        BYSectionHotParam *section4Param = [BYSectionHotParam param];
        section4Param.name = @"4";
        [BYHotTopicTool loadSectionTopicWithParam:section4Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
            NSMutableArray *array = [NSMutableArray array];
            for (BYArticle *article in favoriteResult.article) {
                BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
                hotTopicFrame.article = article;
                [array addObject:hotTopicFrame];
            }
            self.section4Frames = array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
        } whenFailure:^(NSError *error) {
            BYLog(@"%@", error);
        }];
        
        //生活时尚
        BYSectionHotParam *section5Param = [BYSectionHotParam param];
        section5Param.name = @"5";
        [BYHotTopicTool loadSectionTopicWithParam:section5Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
            NSMutableArray *array = [NSMutableArray array];
            for (BYArticle *article in favoriteResult.article) {
                BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
                hotTopicFrame.article = article;
                [array addObject:hotTopicFrame];
            }
            self.section5Frames = array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationNone];
        } whenFailure:^(NSError *error) {
            BYLog(@"%@", error);
        }];
        
        //休闲娱乐
        BYSectionHotParam *section6Param = [BYSectionHotParam param];
        section6Param.name = @"6";
        [BYHotTopicTool loadSectionTopicWithParam:section6Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
            NSMutableArray *array = [NSMutableArray array];
            for (BYArticle *article in favoriteResult.article) {
                BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
                hotTopicFrame.article = article;
                [array addObject:hotTopicFrame];
            }
            self.section6Frames = array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:6] withRowAnimation:UITableViewRowAnimationNone];
        } whenFailure:^(NSError *error) {
            BYLog(@"%@", error);
        }];
        
        //体育健身
        BYSectionHotParam *section7Param = [BYSectionHotParam param];
        section7Param.name = @"7";
        [BYHotTopicTool loadSectionTopicWithParam:section7Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
            NSMutableArray *array = [NSMutableArray array];
            for (BYArticle *article in favoriteResult.article) {
                BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
                hotTopicFrame.article = article;
                [array addObject:hotTopicFrame];
            }
            self.section7Frames = array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:7] withRowAnimation:UITableViewRowAnimationNone];
        } whenFailure:^(NSError *error) {
            BYLog(@"%@", error);
        }];
        
        //游戏对战
        BYSectionHotParam *section8Param = [BYSectionHotParam param];
        section8Param.name = @"8";
        [BYHotTopicTool loadSectionTopicWithParam:section8Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
            NSMutableArray *array = [NSMutableArray array];
            for (BYArticle *article in favoriteResult.article) {
                BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
                hotTopicFrame.article = article;
                [array addObject:hotTopicFrame];
            }
            self.section8Frames = array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:8] withRowAnimation:UITableViewRowAnimationNone];
        } whenFailure:^(NSError *error) {
            BYLog(@"%@", error);
        }];
        
        //乡亲乡爱`
        BYSectionHotParam *section9Param = [BYSectionHotParam param];
        section9Param.name = @"9";
        [BYHotTopicTool loadSectionTopicWithParam:section9Param whenSuccess:^(BYHotTopicResult *favoriteResult) {
            NSMutableArray *array = [NSMutableArray array];
            for (BYArticle *article in favoriteResult.article) {
                BYHotTopicFrame *hotTopicFrame = [[BYHotTopicFrame alloc] init];
                hotTopicFrame.article = article;
                [array addObject:hotTopicFrame];
            }
            self.section9Frames = array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:9] withRowAnimation:UITableViewRowAnimationNone];
        } whenFailure:^(NSError *error) {
            BYLog(@"%@", error);
        }];

    } whenfailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 9) {
        return kBottomBarHeight;
    }else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.hotTopicFrames.count;
            break;
        case 1:
            return self.section1Frames.count;
            break;
        case 2:
            return self.section2Frames.count;
            break;
        case 3:
            return self.section3Frames.count;
            break;
        case 4:
            return self.section4Frames.count;
            break;
        case 5:
            return self.section5Frames.count;
            break;
        case 6:
            return self.section6Frames.count;
            break;
        case 7:
            return self.section7Frames.count;
            break;
        case 8:
            return self.section8Frames.count;
            break;
        case 9:
            return self.section9Frames.count;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYHotTopicFrame *hotTopicFrame;
    
    switch (indexPath.section) {
        case 0:
            hotTopicFrame = self.hotTopicFrames[indexPath.row];
            break;
        case 1:
            hotTopicFrame = self.section1Frames[indexPath.row];
            break;
        case 2:
            hotTopicFrame = self.section2Frames[indexPath.row];
            break;
        case 3:
            hotTopicFrame = self.section3Frames[indexPath.row];
            break;
        case 4:
            hotTopicFrame = self.section4Frames[indexPath.row];
            break;
        case 5:
            hotTopicFrame = self.section5Frames[indexPath.row];
            break;
        case 6:
            hotTopicFrame = self.section6Frames[indexPath.row];
            break;
        case 7:
            hotTopicFrame = self.section7Frames[indexPath.row];
            break;
        case 8:
            hotTopicFrame = self.section8Frames[indexPath.row];
            break;
        case 9:
            hotTopicFrame = self.section9Frames[indexPath.row];
            break;
        default:
            hotTopicFrame = nil;
            break;
    }
    return hotTopicFrame.cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYHotTopicCell *cell = [BYHotTopicCell cellWithTableView:tableView];
    
    BYHotTopicFrame *hotTopicFrame;
    
    switch (indexPath.section) {
        case 0:
            hotTopicFrame = self.hotTopicFrames[indexPath.row];
            break;
        case 1:
            hotTopicFrame = self.section1Frames[indexPath.row];
            break;
        case 2:
            hotTopicFrame = self.section2Frames[indexPath.row];
            break;
        case 3:
            hotTopicFrame = self.section3Frames[indexPath.row];
            break;
        case 4:
            hotTopicFrame = self.section4Frames[indexPath.row];
            break;
        case 5:
            hotTopicFrame = self.section5Frames[indexPath.row];
            break;
        case 6:
            hotTopicFrame = self.section6Frames[indexPath.row];
            break;
        case 7:
            hotTopicFrame = self.section7Frames[indexPath.row];
            break;
        case 8:
            hotTopicFrame = self.section8Frames[indexPath.row];
            break;
        case 9:
            hotTopicFrame = self.section9Frames[indexPath.row];
            break;
        default:
            hotTopicFrame = nil;
            break;
    }
    
    cell.hotTopicFrame = hotTopicFrame;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取出模型数据
    BYHotTopicFrame *hotTopicFrame;
    
    switch (indexPath.section) {
        case 0:
            hotTopicFrame = self.hotTopicFrames[indexPath.row];
            break;
        case 1:
            hotTopicFrame = self.section1Frames[indexPath.row];
            break;
        case 2:
            hotTopicFrame = self.section2Frames[indexPath.row];
            break;
        case 3:
            hotTopicFrame = self.section3Frames[indexPath.row];
            break;
        case 4:
            hotTopicFrame = self.section4Frames[indexPath.row];
            break;
        case 5:
            hotTopicFrame = self.section5Frames[indexPath.row];
            break;
        case 6:
            hotTopicFrame = self.section6Frames[indexPath.row];
            break;
        case 7:
            hotTopicFrame = self.section7Frames[indexPath.row];
            break;
        case 8:
            hotTopicFrame = self.section8Frames[indexPath.row];
            break;
        case 9:
            hotTopicFrame = self.section9Frames[indexPath.row];
            break;
        default:
            hotTopicFrame = nil;
            break;
    }
    
    //创建参数模型
    BYArticleParam *articleParam = [BYArticleParam param];
    articleParam.name = hotTopicFrame.article.board_name;
    NSLog(@"%@", articleParam.name);
    articleParam.BYid = hotTopicFrame.article.BYid;
    
    //创建文章控制器
    BYArticleController *articleVc = [[BYArticleController alloc] init];
    articleVc.articleParam = articleParam;
    articleVc.title = hotTopicFrame.article.title;
    
    //push控制器时隐藏tabbar
    articleVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:articleVc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat viewH = [self tableView:tableView heightForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYScreenW, viewH)];
    view.dk_backgroundColorPicker = DKColor_BACKGROUND;
    
    NSArray *nameArray = [NSArray arrayWithObjects:@"论坛十大", @"北邮校园", @"学术科技", @"信息社会", @"人文艺术", @"生活时尚", @"休闲娱乐", @"体育健身", @"游戏对战", @"乡亲乡爱", nil];
    NSString *text = [nameArray objectAtIndex:section];
    
    
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = BYTableViewTitleFont;
    CGSize titleSize = [text sizeWithAttributes:titleAttr];
    
    CGFloat labelX = (BYScreenW - titleSize.width) * 0.5;
    CGFloat labelY = (viewH - titleSize.height) * 0.5;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, titleSize.width, titleSize.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blueColor];
    titleLabel.font = BYTableViewTitleFont;
    titleLabel.text = text;
    
    CGFloat devide1X = CGRectGetMaxX(titleLabel.frame) + BYBoardArticleMargin;
    CGFloat devide1Y = viewH * 0.5;
    CGFloat devide1W = BYScreenW - devide1X;
    CGFloat devide1H = 1;
    
    UIView *devide1 = [[UIView alloc] initWithFrame:CGRectMake(devide1X, devide1Y, devide1W, devide1H)];
    devide1.backgroundColor = [UIColor lightGrayColor];
    
    UIView *devide2 = [[UIView alloc] initWithFrame:CGRectMake(0, devide1Y, devide1W, devide1H)];
    devide2.backgroundColor = [UIColor lightGrayColor];
    
    [view addSubview:titleLabel];
    [view addSubview:devide1];
    [view addSubview:devide2];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *nameArray = [NSArray arrayWithObjects:@"论坛十大", @"北邮校园", @"学术科技", @"信息社会", @"人文艺术", @"生活时尚", @"休闲娱乐", @"体育健身", @"游戏对战", @"乡亲乡爱", nil];
    NSString *text = [nameArray objectAtIndex:section];
    return text;
}



@end
