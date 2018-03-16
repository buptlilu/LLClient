//
//  BYSQLCacheTool.m
//  缘邮
//
//  Created by LiLu on 16/5/2.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYSQLCacheTool.h"
#import "BYSection.h"
#import "BYAccount.h"
#import "BYAccountTool.h"
#import "BYBoard.h"

#import "FMDB.h"
#import "MJExtension.h"

static FMDatabase *_db;
@implementation BYSQLCacheTool

+ (void)initialize{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"SQLCache.sqlite"];
    //创建了一个数据库实例
    _db = [FMDatabase databaseWithPath:filePath];
    
    if ([_db open]) {
        BYLog(@"打开成功");
    }else{
        BYLog(@"打开失败");
    }
    
    //创建表格
    BOOL flag = [_db executeUpdate:@"create table if not exists BYSQLCache (id integer primary key autoincrement, idstr text, content text, access_token text, dict blob);"];
    
    if (flag) {
        BYLog(@"创建成功");
    }else{
        BYLog(@"创建失败");
    }
}

+ (void)saveWithSections:(NSArray *)sections{
    //先删除之前的,再添加新的
    BOOL flagDelete = [_db executeUpdate:@"delete from BYSQLCache where content = 'sections';"];
    
    //遍历模型数组
    for (NSDictionary *section in sections) {
        NSString *idstr = section[@"name"];
        
        NSString *accessToken = [BYAccountTool account].access_token;
        
        //纯洁的字典
        //        NSDictionary *statusDict = status.keyValues;
        
        BYLog(@"%@", section);
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:section];
        
        
        if (flagDelete) {
            BOOL flag = [_db executeUpdate:@"insert into BYSQLCache (idstr, content, access_token, dict) values (?,?,?,?);", idstr, @"sections", accessToken, data];
            if (flag) {
                BYLog(@"插入成功");
            }else{
                BYLog(@"插入失败");
            }
        }
    }
}

+ (NSArray *)sections{
    //select * from BYSQLCache where access_token = param.accessToken order by idstr desc limit 20;
    //进入程序第一次获取的查询语句
    NSString *sql = [NSString stringWithFormat:@"select * from BYSQLCache where content = '%@' order by idstr desc;", @"sections"];
    
    //返回查询结果
    FMResultSet *set = [_db executeQuery:sql];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        BYSection *section = [BYSection objectWithKeyValues:dict];
        [arrM addObject:section];
    }
    
    return arrM;
}

+ (void)saveWithFavorite:(NSArray *)favorites{
    //先删除之前的,再添加新的
    BOOL flagDelete = [_db executeUpdate:@"delete from BYSQLCache where content = 'favorites';"];
    
    //遍历模型数组
    for (NSDictionary *favorite in favorites) {
        NSString *idstr = favorite[@"name"];
        
        NSString *accessToken = [BYAccountTool account].access_token;
        
        //纯洁的字典
        //        NSDictionary *statusDict = status.keyValues;
        
        BYLog(@"%@", favorite);
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:favorite];
        
        
        if (flagDelete) {
            BOOL flag = [_db executeUpdate:@"insert into BYSQLCache (idstr, content, access_token, dict) values (?,?,?,?);", idstr, @"favorites", accessToken, data];
            if (flag) {
                BYLog(@"插入成功");
            }else{
                BYLog(@"插入失败");
            }
        }
    }
}

+ (NSArray *)favorites{
    //进入程序第一次获取的查询语句
    NSString *sql = [NSString stringWithFormat:@"select * from BYSQLCache where content = '%@';", @"favorites"];
    
    //返回查询结果
    FMResultSet *set = [_db executeQuery:sql];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        BYBoard *board = [BYBoard objectWithKeyValues:dict];
        [arrM addObject:board];
    }
    
    return arrM;
}

@end
