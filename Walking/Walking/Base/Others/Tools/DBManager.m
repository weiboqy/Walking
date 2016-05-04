//
//  DBManager.m
//  Leisure
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

static DBManager *_dbManager = nil;

+ (DBManager *)defaultDBManager:(NSString *)dbName {
    // 互斥锁
    @synchronized(self) {
        if (!_dbManager) {
            _dbManager = [[DBManager alloc] initWithdbName:dbName];
        }
    }
    return _dbManager;
}

- (instancetype)initWithdbName:(NSString *)dbName {
    self = [super init];
    if (self) {
        if (!dbName) {  // 数据库名不存在
            NSLog(@"创建数据库失败！");
        } else {
            // 获取沙盒路径
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            // 创建数据库路径
            NSString *dbPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",dbName]];
            BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
            // exist==0 创建路径成功;  ==1 路径已经存在
            if (!exist) {
                NSLog(@"%@", dbPath);
            } else {
                NSLog(@"%@", dbPath);//数据库路径：
            }
            [self openDB:dbPath];
        }
    }
    return self;
}

//  打开数据库
- (void)openDB:(NSString *)dbPath {
    if (!_dataBase) {
        self.dataBase = [FMDatabase databaseWithPath:dbPath];
    }
    if (![_dataBase open]) {
        NSLog(@"不能打开数据库");
    }
}

//  关闭数据库
- (void) closeDB {
    [_dataBase close];
    _dbManager = nil;
}

- (void) dealloc {
    [self closeDB];
}


@end
