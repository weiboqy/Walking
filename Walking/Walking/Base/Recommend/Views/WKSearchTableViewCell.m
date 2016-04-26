//
//  WKSearchjTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSearchTableViewCell.h"

@implementation WKSearchTableViewCell

- (void)awakeFromNib {    
    
    self.icon.layer.cornerRadius = 6;
    self.icon.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
