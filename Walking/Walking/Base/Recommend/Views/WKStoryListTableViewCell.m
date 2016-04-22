//
//  WKStoryListTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKStoryListTableViewCell.h"


@implementation WKStoryListTableViewCell


- (void)setDetailModel:(WKRecommendStoryDetailModel *)detailModel{
    _detailModel = detailModel;
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:detailModel.photo_s]];
//    _imageV.contentMode = UIViewContentModeScaleAspectFit;
    _titleLabel.text = detailModel.text;
    
}

- (void)awakeFromNib {
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
