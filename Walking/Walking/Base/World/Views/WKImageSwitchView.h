//
//  WKImageSwitchView.h
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKImageSwitchView;

@protocol WKImageSwitchViewDelegate <NSObject>
//  代理方法
- (void)imageSwitchViewDidScroll:(WKImageSwitchView *)imageSwitchView index:(NSInteger)index;

@end

@interface WKImageSwitchView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id <WKImageSwitchViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, assign) float currentIndex;

- (void)setImageSwitchViewArray:(NSArray *)imageSwitchViewArray delegate:(id)delegate;

@end
