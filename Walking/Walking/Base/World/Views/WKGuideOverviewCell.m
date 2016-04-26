//
//  WKGuideOverviewCell.m
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKGuideOverviewCell.h"

@implementation WKGuideOverviewCell

- (void)setModel:(WKGuideDetailSectionsModel *)model {
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    _descriptionLabel.text = [NSString stringWithFormat:@"%@", model.descriptioN];
    [_image_urlImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.photoModel.image_url]] placeholderImage:PLACEHOLDER];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
