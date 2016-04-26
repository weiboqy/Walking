//
//  WKGuideImpressionCell.m
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKGuideImpressionCell.h"

@implementation WKGuideImpressionCell

- (void)setModel:(WKGuideDetailSectionsModel *)model {
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    _descriptionLable.text = [NSString stringWithFormat:@"%@", model.descriptioN];
    _travel_dataLabel.text = [NSString stringWithFormat:@"%@", model.travel_date];
    _nameLabel.text = [NSString stringWithFormat:@"%@", model.userModel.name];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
