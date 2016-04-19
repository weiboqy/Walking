//
//  UIBarButtonItem+WKExtension.h
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WKExtension)

// 自定义一个图片类型的BarButtonItem 
+ (instancetype)itemWithImage:(NSString *)image selectImage:(NSString *)selectImage target:(id)target action:(SEL)action;

@end
