//
//  WKRecommendDB.m
//  Walking
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendDB.h"

@implementation WKRecommendDB

/*
- (instancetype)init{
    self = [super init];
    if (self) {
        _dataBase = [DBManager defaultDBManager:SQLITENAME].dataBase;
    }
    return self;
}

- (void)createDataTable{
    //    FMResultSet *set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name ='ReadDetail'"]];
    //    [set next];
    //    NSInteger count = [set intForColumn:0];
    //    if (count) {
    //        NSLog(@"数据表已经存在");
    //    }else{
    //        NSString *sql = [NSString stringWithFormat:@"create table ReadDetail(readID integer primary key autoincrement not null, userID text, tilte text,contentID text, conent text, name text, coverimg text)"];
    //        BOOL res = [_dataBase executeQuery:sql];
    //        if (res) {
    //            NSLog(@"数据表创建成功");
    //        }else{
    //            NSLog(@"数据表创建失败");
    //        }
    //    }
    // 查询数据表中元素个数
    FMResultSet * set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'", READDETAILTABLE]];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        NSLog(@"数据表已经存在");
    } else {
        // 创建新的数据表
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ (readID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, userID text, title text, contentID text, content text, name text, coverimg text)", READDETAILTABLE];
        BOOL res = [_dataBase executeUpdate:sql];
        if (res) {
            NSLog(@"数据表创建成功");
        } else {
            NSLog(@"数据表创建失败");
        }
    }
}
//传入的是模型参数
- (void)saveDetailModel:(ReadDetailModel *)detailModel{
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO %@(userID, title, contentid, content, name, coverimg) values (?,?,?,?,?,?)", READDETAILTABLE];
    //创建插入内容
    NSMutableArray *arguments = [[NSMutableArray alloc] initWithCapacity:0];
    if (![[UserInfoManager getUserID] isEqualToString:@" "]) {
        [arguments addObject:[UserInfoManager getUserID]];
    }
    if (detailModel.title) {
        [arguments addObject:detailModel.title];
    }
    if (detailModel.contentid) {
        [arguments addObject:detailModel.contentid];
    }
    if (detailModel.content) {
        [arguments addObject:detailModel.content];
    }
    if (detailModel.name) {
        [arguments addObject:detailModel.name];
    }
    if (detailModel.coverimg) {
        [arguments addObject:detailModel.coverimg];
    }
    NSLog(@"%@",query);
    NSLog(@"收藏一条数据");
    // 执行语句
    [_dataBase executeUpdate:query withArgumentsInArray:arguments];
}

- (void)deleteDetailWithTiele:(NSString *)detailTitle{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE title = '%@'", READDETAILTABLE, detailTitle];
    NSLog(@"删除成功");
    [_dataBase executeUpdate:query];
}

- (NSArray *)findWithUserID:(NSString *)userID{
    NSString *query = [NSString stringWithFormat:@"select *from %@ where userID = '%@'", READDETAILTABLE, userID];
    FMResultSet *set = [_dataBase executeQuery:query];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[set columnCount]];
    while ([set next]) {
        ReadDetailModel * detailModel = [[ReadDetailModel alloc] init];
        detailModel.title = [set stringForColumn:@"title"];
        detailModel.contentid = [set stringForColumn:@"contentid"];
        detailModel.content = [set stringForColumn:@"content"];
        detailModel.name = [set stringForColumn:@"name"];
        detailModel.coverimg = [set stringForColumn:@"coverimg"];
        [array addObject:detailModel];
    }
    [set close];
    return array;
}
*/


@end
