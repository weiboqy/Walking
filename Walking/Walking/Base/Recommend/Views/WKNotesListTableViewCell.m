//
//  WKNotesListTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKNotesListTableViewCell.h"

@implementation WKNotesListTableViewCell

/*
 @property (strong, nonatomic) IBOutlet UILabel *dayTimeLabel;
 @property (strong, nonatomic) IBOutlet UIImageView *imageV;
 @property (strong, nonatomic) IBOutlet UILabel *contentLabel;
 @property (strong, nonatomic) IBOutlet UILabel *timeLabel;
 */
- (void)setDetailModel:(WKRecommendNotesDetailModel *)detailModel
{
    _detailModel = detailModel;
    NSString *str = [(NSString *)detailModel.date substringFromIndex:5];
    _dayTimeLabel.text = [NSString stringWithFormat:@"第%@天 %@", detailModel.DAY, str];
    _timeLabel.text = detailModel.date;

    [_imageV sd_setImageWithURL:[NSURL URLWithString:detailModel.photo] placeholderImage:PLACEHOLDER];
    _imageV.layer.cornerRadius = 6;
    _imageV.layer.masksToBounds = YES;
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    _imageV.userInteractionEnabled = YES;
    
    _contentLabel.text = detailModel.text;    
    self.imageC.layer.cornerRadius = 6;
    self.imageC.layer.masksToBounds = YES;
    
}


- (void)awakeFromNib {
    
    self.imageC.layer.cornerRadius = 6;
    self.imageC.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
