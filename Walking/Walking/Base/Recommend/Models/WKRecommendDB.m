//
//  WKRecommendDB.m
//  Walking
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendDB.h"
@implementation WKRecommendDB

- (instancetype)init{
    self = [super init];
    if (self) {
        _dataBase = [DBManager defaultDBManager:SQLITENAME].dataBase;
    }
    return self;
}

- (void)createDataTable{   
    // 查询数据表中元素个数
    FMResultSet * set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'", COLLECTTABLE]];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        WKLog(@"数据表已经存在");
    } else {
        // 创建新的数据表
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ (readID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, ID text, title text, imageURL text, type text)", COLLECTTABLE];
        BOOL res = [_dataBase executeUpdate:sql];
        if (res) {
            WKLog(@"数据表创建成功");
        } else {
            WKLog(@"数据表创建失败");
        }
    }
}
//传入的是模型参数
- (void)saveDetailID:(NSString *)ID title:(NSString *)title imageURL:(NSString *)imageURL type:(NSString *)type{
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO %@(ID, title, imageURL, type) values (?,?,?,?)", COLLECTTABLE];
    //创建插入内容
    NSMutableArray *arguments = [[NSMutableArray alloc] initWithCapacity:0];
//    if (![[UserInfoManager getUserID] isEqualToString:@" "]) {
//        [arguments addObject:[UserInfoManager getUserID]];
//    }
    
    if (ID) {
        [arguments addObject:ID];
    }
    if (title) {
        [arguments addObject:title];
    }
    if (imageURL) {
        [arguments addObject:imageURL];
    }
    if (type) {
        [arguments addObject:type];
    }
    WKLog(@"%@",query);
    WKLog(@"收藏一条数据");
    // 执行语句
    [_dataBase executeUpdate:query withArgumentsInArray:arguments];
}

- (void)deleteWithTitle:(NSString *)title{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE title = '%@'", COLLECTTABLE, title];
    WKLog(@"删除成功");
    [_dataBase executeUpdate:query];
}

- (NSArray *)findWithID:(NSString *)ID{
    NSString *query = [NSString stringWithFormat:@"select *from %@ where ID = '%@'", COLLECTTABLE, ID];
    FMResultSet *set = [_dataBase executeQuery:query];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[set columnCount]];
    while ([set next]) {
        NSString *title    = [set stringForColumn:@"title"];
        NSString *ID       = [set stringForColumn:@"ID"];
        NSString *imageURL = [set stringForColumn:@"imageURL"];
        NSString *type     = [set stringForColumn:@"type"];
        
        [array addObject:title];
        [array addObject:ID];
        [array addObject:imageURL];
        [array addObject:type];
    }
    [set close];
    return array;
}



@end
