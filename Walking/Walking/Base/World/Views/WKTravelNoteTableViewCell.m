//
//  WKTravelNoteTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKTravelNoteTableViewCell.h"

@implementation WKTravelNoteTableViewCell

- (void)setModel:(WKTravelNoteModel *)model {
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@", model.name];
    _start_dateLabel.text = [NSString stringWithFormat:@"%@", model.start_date];
    _daysLabel.text = [NSString stringWithFormat:@"%@", model.days];
    _likes_count.text = [NSString stringWithFormat:@"%@", model.photos_count];
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.front_cover_photo_url]] placeholderImage:PLACEHOLDER];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
