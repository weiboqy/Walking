//
//  WKDarkLightMode.m
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKDarkLightMode.h"

@interface WKDarkLightMode ()

@property (nonatomic, weak) UIView *bgView;

@end

@implementation WKDarkLightMode

+ (instancetype)defaultManager {
    static WKDarkLightMode *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WKDarkLightMode alloc] init];
    });
    return manager;
}

/** 黑夜 */
- (void)darkmode {
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    bgView.userInteractionEnabled = NO;
//    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    self.bgView = bgView;
//    [vc.view insertSubview:self.bgView atIndex:[UIApplication sharedApplication].windows.count];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
}

/** 白天 */
- (void)lightmode {
    [self.bgView removeFromSuperview];
}

@end
