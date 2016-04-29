//
//  WKSearchDetailViewControllerCell.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSearchDetailViewControllerCell.h"

@implementation WKSearchDetailViewControllerCell

- (void)awakeFromNib {
    self.imageV.layer.cornerRadius = 10;
    self.imageV.layer.masksToBounds = YES;
    self.contentView.backgroundColor = ColorGlobal;
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
