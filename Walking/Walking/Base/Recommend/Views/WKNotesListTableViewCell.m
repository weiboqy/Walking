//
//  WKNotesListTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKNotesListTableViewCell.h"
#define Margin 10

@implementation WKNotesListTableViewCell


- (void)setDetailModel:(WKRecommendNotesDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    
    NSString *string = [NSString stringWithFormat:@"%@", detailModel.local_time];
    NSString *str = [string substringWithRange:NSMakeRange(5, 5)];
    _dayTimeLabel.text = [NSString stringWithFormat:@"第%@天 %@", detailModel.DAY, str];
    _timeLabel.text = [NSString stringWithFormat:@"%@", detailModel.local_time];

    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", detailModel.photo]] placeholderImage:PLACEHOLDER];
    _imageV.layer.cornerRadius = 6;
    _imageV.layer.masksToBounds = YES;
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _imageV.userInteractionEnabled = YES;
    
    _contentLabel.text = [NSString stringWithFormat:@"%@", detailModel.text];
    
    self.imageC.layer.cornerRadius = 6;
    self.imageC.layer.masksToBounds = YES;
    
}



- (void)awakeFromNib {
    
//    self.imageC.layer.cornerRadius = 6;
//    self.imageC.layer.masksToBounds = YES;
//    
    // Initialization code
}


//- (void)layoutSubviews{
//    WKLog(@"layoutSubviews");
//    [super layoutSubviews];
//    
//    _imageV.height       = self.detailModel.imageH;
//    _contentLabel.height = self.detailModel.textH;
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
