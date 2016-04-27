//
//  WKRouteDetailCell.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRouteDetailCell.h"

@implementation WKRouteDetailCell

- (void)setModel:(WKRoutePlanModel *)model {
    _model = model;
    _entry_nameLabel.text = [NSString stringWithFormat:@"%@", model.entry_name];
    _tipsLabel.text = [NSString stringWithFormat:@"%@", model.tips];
    [_image_urlImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.image_url]] placeholderImage:PLACEHOLDER];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
