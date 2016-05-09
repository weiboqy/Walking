//
//  WKRecommendListModel.h
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKRecommendListUserModel.h"

@interface WKRecommendListModel : NSObject


@property (nonatomic, strong) NSString *cover_image; //背景大图
@property (nonatomic, strong) NSString *name;    //标题
@property (nonatomic, strong) NSString *popular_place_str;//地址详情名字
@property (nonatomic, strong) NSString *view_count;//浏览量
@property (nonatomic, strong) NSString *day_count;//共计天数
@property (nonatomic, strong) NSString *first_day;//时间
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *desc;

//作者信息
@property (nonatomic, strong) WKRecommendListUserModel *userMosel;


@end
