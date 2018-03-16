//
//  BYMeBaseController.m
//  缘邮
//
//  Created by LiLu on 16/2/15.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYMeBaseController.h"
#import "BYGroupItem.h"
#import "BYSettingCell.h"
#import "BYSettingItem.h"

@interface BYMeBaseController ()

@end

@implementation BYMeBaseController

-(NSMutableArray *)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

-(instancetype)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//返回多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.groups.count;
}

//返回多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BYGroupItem *group = self.groups[section];
    return group.items.count;
}

//返回每一行长什么样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.创建cell
    BYSettingCell *cell = [BYSettingCell cellWithTableView:tableView];
    
    //2.给cell传递模型
    BYGroupItem *group = self.groups[indexPath.section];
    
    BYSettingItem *item = group.items[indexPath.row];
    
    cell.item = item;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    BYGroupItem *group = self.groups[section];
    return group.footerTitle;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    BYGroupItem *group = self.groups[section];
    return group.headerTitle;
}

//点击某一行cell的时候做事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取出模型
    BYGroupItem *group = self.groups[indexPath.section];
    BYSettingItem *item = group.items[indexPath.row];
    
    if (item.option) {
        //有事情就直接做
        item.option(item);
        return;
    }
    
    //跳转控制器
    if (item.destVcClass) {
        //有才需要跳转
        
        UIViewController *destVc = [[item.destVcClass alloc] init];
        [self.navigationController pushViewController:destVc animated:YES];
    }
}


@end
