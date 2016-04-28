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
}


//  返回cell的高度
- (CGFloat)cellsHeight{
    
    CGFloat imageH = self.photoModel.h;
    CGFloat imageW = self.photoModel.w;
    CGFloat flo = 0;
    
    if (!_cellHeight) {
       
        if (![self.photo isEqualToString:@""]) {
            
            if ( self.photoModel.w > (kScreenWidth - Margin * 2)) {
                imageH =  self.photoModel.h * (kScreenWidth - Margin * 2) / imageW;
                imageW = kScreenWidth - Margin * 2;
            }
            _imageFrame = CGRectMake(Margin, Margin/2, imageW, imageH);
            ////fgdfgdfgd
            _imageH = imageH;
//            _cellHeight += Margin/2 + _imageFrame.size.height;
            _cellHeight += Margin/2 + imageH;
        }
        
        NSString *string = self.text;
        CGSize maxSize = CGSizeMake(kScreenWidth - Margin * 2, MAXFLOAT);
        CGFloat textH = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        CGFloat textY = CGRectGetMaxY(self.imageFrame) + Margin;
        self.textFrame = CGRectMake(Margin, textY, maxSize.width, textH);
        //返回 text 的高度。 给外界使用
        _textH = textH;
        flo = textH;
        if (![self.text isEqualToString:@""]) {
            _cellHeight += Margin/2 + textH + Margin;
//            WKLog(@"celllll:%f", _cellHeight);
        }else{
//            _cellHeight += Margin/2;
        }
    }
    return imageH + flo + 60;
}


@end
