//
//  WKRecommendSearchModel.h
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKRecommendSearchModel : NSObject


//游记显示内容
@property (nonatomic, copy) NSString *name;//标题
@property (nonatomic, copy) NSString *day_count;//共计天数
@property (nonatomic, copy) NSString *cover_image;//图片
@property (nonatomic, copy) NSString *ID;//点击到游记的id
@property (nonatomic, copy) NSString *more;//是否 有数据

@end
