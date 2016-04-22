//
//  WKCycleScrollView.h
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCycleScrollView : UIView<UIScrollViewDelegate>
/*
 自定义初始化方法
 参数：
 frame: 定义滚动视图的大小
 animationDuration: 滚动的时间间隔
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;
/*
 设置三个属性，分别是：
 1 设置轮播图的总个数
 2 Block设置轮播的视图
 3 Block设置轮播图点击的方法
 */
// 页面图片的总个数
@property (nonatomic, assign) NSInteger totalPagesCount;
@property (nonatomic, strong) NSMutableArray *array;

// 刷新视图
@property (nonatomic, copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
// 点击页面
@property (nonatomic, copy) void (^TapActionBlock)(NSInteger pageIndex);


@end
