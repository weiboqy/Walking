//
//  WKRecommendStoryDetailModel.h
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKRecommendStoryDetailModel : NSObject

//@property (nonatomic, copy) NSString *uName;//作者姓名
//@property (nonatomic, copy) NSString *avatar_l;//头像
//@property (nonatomic, copy) NSString *name;//trip旅行家
//@property (nonatomic, copy) NSString *date_added;//时间

//@property (nonatomic, copy) NSString *text;//第一条标题
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *photo_s;

@property (nonatomic, assign) CGRect  imageFrame;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat photo_width;
@property (nonatomic, assign) CGFloat photo_height;

- (CGFloat)cellsHeight;


@end
