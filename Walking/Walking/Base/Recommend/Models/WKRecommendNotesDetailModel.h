//
//  WKRecommendNotesDetailModel.h
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKRecommendNotesDetailModel : NSObject

@property (nonatomic, copy) NSString *name;//标题
@property (nonatomic, copy) NSString *mileage;//里程
@property (nonatomic, copy) NSString *day_count;//时间数
@property (nonatomic, copy) NSString *recommendations;//喜欢数
@property (nonatomic, copy) NSString *uName;
@property (nonatomic, copy) NSString *trackpoints_thumbnail_image;//地图
@property (nonatomic, copy) NSString *avatar_m;//头像

//cell 图片等的具体内容
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *DAY;

@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *text;


@end
