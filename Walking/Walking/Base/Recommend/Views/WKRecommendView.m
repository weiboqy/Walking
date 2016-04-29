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
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12/375.0 * kScreenWidth, self.headScrolView.frame.size.height + 10/667.0 * kScreenHeight, 5/375.0*kScreenWidth, 20/667.0*kScreenHeight)];
        view.layer.cornerRadius = 2;
        view.backgroundColor = [UIColor orangeColor];
        [self addSubview:view];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(25/375.0*kScreenWidth, self.headScrolView.frame.size.height + 5/667.0*kScreenHeight, 200/375.0*kScreenWidth, 30/667.0*kScreenHeight)];
        _label.text = @"精选故事";
        _label.font = [UIFont systemFontOfSize:17.0/375*kScreenWidth];
        [self addSubview:_label];
        
        //button 按钮
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreButton.frame = CGRectMake(self.bounds.size.width - 60/375.0*kScreenWidth, self.headScrolView.frame.size.height + 5/667.0*kScreenHeight, 50/375.0*kScreenWidth, 30/667.0*kScreenHeight);
        [self.moreButton setTitle: @"更多" forState:UIControlStateNormal];
//        _moreButton font = [UIFont systemFontOfSize:17.0/375*kScreenWidth];
        [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self.moreButton setTitle:@"更多" forState:UIControlStateHighlighted];
//        [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        [self.moreButton addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchDown)];
        [self addSubview:self.moreButton];
        
        //创建celloctionView
        [self createCollectionView];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(12/375.0*kScreenWidth, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 10/667.0*kScreenHeight, 5/375.0*kScreenWidth, 20/667.0*kScreenHeight)];//540
        view2.layer.cornerRadius = 2;
        view2.backgroundColor = [UIColor orangeColor];
        [self addSubview:view2];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(25/375.0*kScreenWidth, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 5/667.0*kScreenHeight, 200/375.0*kScreenWidth, 30/667.0*kScreenHeight)];//535
        label2.text = @"精彩游记";
        
        [self addSubview:label2];
    }
    return self;
}

//创建 scrollView 轮播图
- (void)createScrollView{
    
//   double flo = [UIScreen mainScreen].bounds.size.height;
    
    //1 初始话布局
    self.headScrolView = [[WKCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.305*self.frame.size.height) animationDuration:2];//180
    [self addSubview:self.headScrolView];
}

- (void)createCollectionView{
//    double flo = [UIScreen mainScreen].bounds.size.height;
    //collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(7/375.0*kScreenWidth, _label.frame.origin.y + 35/667.0*kScreenHeight, kScreenWidth - 14/375.0*kScreenWidth, 0.559 * self.frame.size.height) collectionViewLayout:layout];//330
    self.collectionView.layer.cornerRadius = 3;
    self.collectionView.backgroundColor = ColorGlobal;
    self.collectionView.showsHorizontalScrollIndicator = NO;//水平的滑动条 关闭
    self.collectionView.pagingEnabled = YES;
    
//    self.collectionView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(collectionHeadRefreshData)];
//    self.collectionView.
    [self addSubview:self.collectionView];
}
//- (void)collectionHeadRefreshData{
//    
//        WKLog(@"collection下啦开始了");
//}


@end
