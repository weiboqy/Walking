//
//  UIImage+WKExtension.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "UIImage+WKExtension.h"

@implementation UIImage (WKExtension)

/** 根据颜色生成一张照片 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //使用颜色填充上下文
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    //渲染图形上下文
    CGContextFillRect(context, rect);
    
    //获取上下文
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
