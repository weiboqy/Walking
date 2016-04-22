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
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, self.headScrolView.frame.size.height + 10, 5, 20)];
        view.layer.cornerRadius = 2;
        view.backgroundColor = [UIColor orangeColor];
        [self addSubview:view];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(25, self.headScrolView.frame.size.height + 5, 200, 30)];
        _label.text = @"精选故事";
        [self addSubview:_label];
        
        //button 按钮
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreButton.frame = CGRectMake(self.bounds.size.width - 75, self.headScrolView.frame.size.height + 5, 50, 30);
        [self.moreButton setTitle: @"更多" forState:UIControlStateNormal];
        [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self.moreButton setTitle:@"更多" forState:UIControlStateHighlighted];
//        [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        [self.moreButton addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchDown)];
        [self addSubview:self.moreButton];
        
        //创建celloctionView
        [self createCollectionView];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(12, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 10, 5, 20)];//540
        view2.layer.cornerRadius = 2;
        view2.backgroundColor = [UIColor orangeColor];
        [self addSubview:view2];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(25, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 5, 200, 30)];//535
        label2.text = @"精彩游记";
        
        [self addSubview:label2];
    }
    return self;
}

//创建 scrollView 轮播图
- (void)createScrollView{
    
    //1 初始话布局
    self.headScrolView = [[WKCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 160) animationDuration:2];
    [self addSubview:self.headScrolView];
}

- (void)createCollectionView{
    
    //collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _label.frame.origin.y + 35, self.bounds.size.width - 10, 330) collectionViewLayout:layout];
    self.collectionView.layer.cornerRadius = 3;
    self.collectionView.backgroundColor = ColorGlobal;
    self.collectionView.showsHorizontalScrollIndicator = NO;//水平的滑动条 关闭
    self.collectionView.pagingEnabled = YES;
    [self addSubview:self.collectionView];
}



@end
