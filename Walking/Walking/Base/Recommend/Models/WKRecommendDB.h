//
//  WKRecommendDB.h
//  Walking
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "FMDB.h"

@interface WKRecommendDB : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

/*
- (void)createDataTable;
- (void)saveDetailModel:(ReadDetailModel *)detailModel;
- (void)deleteDetailWithTiele:(NSString *)detailTitle;
- (NSArray *)findWithUserID:(NSString *)userID;
*/







@end
