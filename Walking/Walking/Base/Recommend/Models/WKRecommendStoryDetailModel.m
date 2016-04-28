//
//  WKRecommendStoryDetailModel.m
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendStoryDetailModel.h"
#define Margin 10

@implementation WKRecommendStoryDetailModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


//  返回cell的高度
- (CGFloat)cellsHeight{
    if (!_cellHeight) {
        if (![self.photo_s isEqualToString:@""]) {
            CGFloat imageH = self.photo_height;
            CGFloat imageW = self.photo_width;
            if ( self.photo_width > (kScreenWidth - Margin * 2)) {
                imageH =  self.photo_height * (kScreenWidth - Margin * 2) / imageW;
                imageW = kScreenWidth - Margin * 2;
            }
            _imageFrame = CGRectMake(Margin, Margin/2, imageW, imageH);
            _cellHeight += Margin/2 + _imageFrame.size.height;
        }
        
        NSString *string = self.text;
        CGSize maxSize = CGSizeMake(kScreenWidth - Margin * 2, MAXFLOAT);
        CGFloat textH = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        CGFloat textY = CGRectGetMaxY(self.imageFrame) + Margin;
        self.textFrame = CGRectMake(Margin, textY, maxSize.width, textH);
        
        if (![self.text isEqualToString:@""]) {
            _cellHeight += Margin/2 + textH + Margin;
        }else{
            _cellHeight += Margin/2;
        }
    }
    return _cellHeight;
}



@end
