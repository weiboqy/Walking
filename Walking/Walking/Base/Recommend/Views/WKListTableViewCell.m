//
//  WKListTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKListTableViewCell.h"

@implementation WKListTableViewCell

- (void)awakeFromNib {
    
    self.view.layer.cornerRadius = 3;
    self.icon.layer.cornerRadius = 15;
    self.backImageV.layer.cornerRadius = 5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
