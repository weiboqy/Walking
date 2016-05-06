//
//  WKRecommendNotesDetailModel.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendNotesDetailModel.h"
#define Margin 10

@implementation WKRecommendNotesDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
 
    if ([key isEqualToString:@"day"]) {
        _DAY = value;
    }
    if ([key isEqualToString:@"text"]) {
        _text = value;
    }
}


- (CGFloat)cellsHeightWithImageH:(CGFloat)imageH imageW:(CGFloat)imageW  textStr:(NSString *)textStr{
    //w 1600,  h 1200
//    WKLog(@"h:%f, w:%f",  imageH,  imageW);
//    CGFloat floImageW = [imageW floatValue];
//    CGFloat floImageH = [imageH floatValue];
//
    CGFloat imageHeight = imageH;
    
    if ( imageW > (kScreenWidth - Margin * 2)) {
        if (!imageW == 0.0) {
            imageHeight =  imageH * (kScreenWidth - Margin * 2) / imageW;
        }
    }
    
    CGSize maxSize = CGSizeMake(kScreenWidth - Margin * 2, MAXFLOAT);
    CGFloat textH = [textStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
     //返回
//    WKLog(@"%f", imageHeight + textH + 60.0);
    return imageHeight + textH + 60.0/667*kScreenHeight;
}
@end
