//
//  WKCollectionTableViewCell.m
//  Walking
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKCollectionTableViewCell.h"

@implementation WKCollectionTableViewCell

- (void)awakeFromNib {
    _bgView.backgroundColor = [UIColor colorWithRed:arc4random() % 200 / 255.0 green:arc4random() % 200 / 255.0 blue:arc4random() % 200 / 255.0 alpha:0.5];
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectview.frame = _bgView.frame;
//    [_bgView insertSubview:effectview atIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
