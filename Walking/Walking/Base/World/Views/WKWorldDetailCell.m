//
//  WKWorldDetailCell.m
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKWorldDetailCell.h"

@implementation WKWorldDetailCell

- (void)setModel:(WKWorldDetailModel *)model {
    _model = model;
    self.name_zh_cnLabel.text = [NSString stringWithFormat:@"%@", model.name_zh_cn];
    self.name_enLabel.text = [NSString stringWithFormat:@"%@", model.name_en];
    [self.image_urlImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.image_url]] placeholderImage:PLACEHOLDER];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
