//
//  HeadView.h
//  tupianlashen
//
//  Created by lanou on 16/4/17.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HeadView : NSObject

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *view;

/*
 subview:内容部分
 View:拉伸的背景图片
 */
- (void) stretchHeaderForTableView:(UITableView *)tableView withView:(UIView *)view subView:(UIView *)subView;

- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

- (void)resizeView;

@end
/*
 *使用时要实现以下两个代理方法
 *- (void)scrollViewDidScroll:(UIScrollView *)scrollView
 *- (void)viewDidLayoutSubviews
 */