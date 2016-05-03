//
//  WKRecommendNotesDetailModel.h
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKRecommendNotesDetailPhotoModel.h"

@interface WKRecommendNotesDetailModel : NSObject


//cell 图片等的具体内容
@property (nonatomic, copy) NSString *local_time;
@property (nonatomic, copy) NSString *DAY;

@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *text;


@property (nonatomic, strong) WKRecommendNotesDetailPhotoModel *photoModel;

- (CGFloat)cellsHeightWithImageH:(CGFloat)imageH imageW:(CGFloat)imageW  textStr:(NSString *)textStr;



@end
