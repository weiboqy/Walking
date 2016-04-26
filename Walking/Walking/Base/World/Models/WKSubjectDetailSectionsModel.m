//
//  WKSubjectDetailSectionsModel.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSubjectDetailSectionsModel.h"

#define Margin 10

@implementation WKSubjectDetailSectionsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        _Description = value;
    }
}

//  返回cell的高度
- (CGFloat)cellHeight {
    if (!_cellHeight) {
        if (self.image_width != 0) {
            CGFloat imageH = self.image_height;
            CGFloat imageW = self.image_width;
            if (self.image_width > (kScreenWidth - Margin * 2)) {
                imageH =  self.image_height * (kScreenWidth - Margin * 2) / imageW;
                imageW = kScreenWidth - Margin * 2;
            }
            _imageFrame = CGRectMake(Margin, Margin, imageW, imageH);
            _cellHeight += Margin + _imageFrame.size.height;
        }

        NSString *string = self.Description;
        CGSize maxSize = CGSizeMake(kScreenWidth - Margin * 2, MAXFLOAT);
        CGFloat textH = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;

        CGFloat textY = CGRectGetMaxY(self.imageFrame) + Margin;
        self.textFrame = CGRectMake(Margin, textY, maxSize.width, textH);
        
        _cellHeight += Margin + textH + Margin;
    }
    
    return _cellHeight;
}

@end
