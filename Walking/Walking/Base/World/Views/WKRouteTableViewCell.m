//
//  WKRouteTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRouteTableViewCell.h"

@implementation WKRouteTableViewCell

- (void)setModel:(WKRouteModel *)model {
    _model = model;
    [_image_urlImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.image_url]] placeholderImage:PLACEHOLDER];
    _image_urlImage.contentMode = UIViewContentModeScaleAspectFill;
    _image_urlImage.clipsToBounds = YES;
    _image_urlImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _nameLabel.text = [NSString stringWithFormat:@"%@", model.name];
    _dayslabel.text = [NSString stringWithFormat:@"%@/", model.plan_days_count];
    _plan_nodes_countsLabel.text = [NSString stringWithFormat:@" 7个游行地"];
    _descLabel.text = [NSString stringWithFormat:@"%@", model.descriptioN];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
