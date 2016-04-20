//
//  WKNotesListHeadView.h
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKNotesListHeadView : UIView

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *mileageLabel;
@property (nonatomic, strong) UILabel *motreLabel;
@property (nonatomic, strong) UILabel *loveLabel;
@property (nonatomic, strong) UILabel *countLabel;



- (instancetype)initWithFrame:(CGRect)frame;



@end
