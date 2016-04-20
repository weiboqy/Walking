//
//  WKRecommendView.h
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKCycleScrollView.h"
#import "WKRecommendCollectionViewCell.h"

@interface WKRecommendView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WKCycleScrollView *headScrolView;


- (instancetype)initWithFrame:(CGRect)frame;






@end
