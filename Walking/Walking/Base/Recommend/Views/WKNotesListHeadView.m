//
//  WKNotesListHeadView.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKNotesListHeadView.h"

@implementation WKNotesListHeadView
/*
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

 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = ColorGlobal;
        
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 120)];
        self.imageV.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.imageV];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake((375 - 30)/2, 0, 50, 50)];
        CGPoint p = self.imageV.center;
        self.icon.center = CGPointMake(p.x, p.y * 2);
        self.icon.layer.cornerRadius = 25;
        self.icon.backgroundColor = [UIColor orangeColor];;
        [self addSubview:self.icon];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
        self.nameLabel.center = CGPointMake(p.x, p.y * 2 + 45);
        self.nameLabel.text = @"by";
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
//        self.nameLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:self.nameLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.nameLabel.frame.origin.y + 30, 375 - 40, 30)];
//        self.titleLabel.backgroundColor = [UIColor grayColor];
        self.titleLabel.text = @"-----title----";
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.titleLabel];
        
        
        self.motreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        self.motreLabel.textAlignment = NSTextAlignmentCenter;
        self.motreLabel.center = CGPointMake(375/2, 250);
        self.motreLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:self.motreLabel];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, self.titleLabel.frame.origin.y + 40, 60, 50)];
        self.timeLabel.backgroundColor = [UIColor grayColor];
        self.timeLabel.text = @"11        001";
        self.timeLabel.numberOfLines = 0;
        CGPoint pl = self.motreLabel.center;
        self.timeLabel.center = CGPointMake(pl.x - 100, pl.y);
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.timeLabel];
        
        
        self.loveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        self.loveLabel.center = CGPointMake(pl.x + 100, pl.y);
        self.loveLabel.backgroundColor = [UIColor grayColor];
        self.loveLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.loveLabel];
        
    }
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
