//
//  WKCollectionCell.m
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKCollectionCell.h"

@implementation WKCollectionCell
- (void)setModel:(WKWorldListModel *)model {
    _model = model;
    _name_zh_cnLabel.text = [NSString stringWithFormat:@"%@", model.name_zh_cn];
    _name_enLabel.text = [NSString stringWithFormat:@"%@", model.name_en];
    _poi_countLabel.text = [NSString stringWithFormat:@"旅行地 %ld", model.poi_count];
    [_image_urlImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.image_url]] placeholderImage:PLACEHOLDER];
    
    
}

@end
