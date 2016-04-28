//
//  WKListTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKListTableViewCell.h"

@implementation WKListTableViewCell


- (void)setListModel:(WKRecommendListModel *)listModel{
    
    
    _listModel = listModel;
    
    _titleLabel.text = listModel.name;
    
    [_backImageV sd_setImageWithURL:[NSURL URLWithString:listModel.cover_image] placeholderImage:PLACEHOLDER];
    _backImageV.contentMode = UIViewContentModeScaleAspectFill;
    _backImageV.clipsToBounds = YES;
    _backImageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    _backImageV.contentMode = UIViewContentModeScaleAspectFit;//图片的自适应大小
    //毛玻璃效果
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectview.frame = CGRectMake(0, 0, 375 - 20, 180);
//    effectview.alpha = 0.3;
//    [_backImageV addSubview:effectview];
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:listModel.userMosel.cover] placeholderImage:PLACEHOLDER];
    _userName.text = listModel.userMosel.name;
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@天 %@浏览量", listModel.first_day, listModel.day_count, listModel.view_count];
    _addressLabel.text = listModel.popular_place_str;
    
//    WKLog(@"%@", _titleLabel.text);
}


- (void)awakeFromNib {
    
    self.view.layer.cornerRadius = 3;
    self.icon.layer.cornerRadius = 22;
    self.icon.layer.masksToBounds = YES;
    self.backImageV.layer.cornerRadius = 5;
    self.backImageV.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
