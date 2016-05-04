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
#import "WKCollectModel.h"

@interface WKRecommendDB : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;


- (void)createDataTable;

- (void)saveDetailID:(NSString *)ID title:(NSString *)title imageURL:(NSString *)imageURL type:(NSString *)type;

- (void)deleteWithTitle:(NSString *)title;

- (NSArray *)findWithID:(NSString *)ID;

- (NSArray *)getAllDataWithCollectModel:(WKCollectModel *)collectModel;


@end
