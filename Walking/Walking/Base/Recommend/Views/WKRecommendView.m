//
//  WKRecommendView.m
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendView.h"

@interface WKCycleScrollView ()



@end

@implementation WKRecommendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //轮播图
        [self createScrollView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 170, 5, 20)];
        view.layer.cornerRadius = 2;
        view.backgroundColor = [UIColor orangeColor];
        [self addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 165, 200, 30)];
        label.text = @"每日精选故事";
        [self addSubview:label];
        //button 按钮
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreButton.frame = CGRectMake(300, 165, 50, 30);
        [self.moreButton setTitle: @"更多" forState:UIControlStateNormal];
        [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self.moreButton setTitle:@"更多" forState:UIControlStateHighlighted];
//        [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        [self.moreButton addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchDown)];
        [self addSubview:self.moreButton];
        
        //创建celloctionView
        [self createCollectionView];
        
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(12, 540, 5, 20)];
        view2.layer.cornerRadius = 2;
        view2.backgroundColor = [UIColor orangeColor];
        [self addSubview:view2];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(25, 535, 200, 30)];
        label2.text = @"精彩游记和专题";
        [self addSubview:label2];
    }
    return self;
}


- (void)createCollectionView{
    
    //collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, 375 - 10, 330) collectionViewLayout:layout];
    self.collectionView.layer.cornerRadius = 3;
    self.collectionView.backgroundColor = ColorGlobal;
    self.collectionView.showsHorizontalScrollIndicator = NO;//水平的滑动条 关闭
    self.collectionView.pagingEnabled = YES;
    [self addSubview:self.collectionView];
}

//创建 scrollView 轮播图
- (void)createScrollView{
    
    //1 初始话布局
     self.headScrolView = [[WKCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 160) animationDuration:2];
    [self addSubview:self.headScrolView];
}

@end
