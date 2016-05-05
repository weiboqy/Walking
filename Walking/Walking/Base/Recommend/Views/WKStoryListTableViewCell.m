//
//  WKStoryListTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKStoryListTableViewCell.h"


@implementation WKStoryListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_imageV];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}


//#warning mark-----------imageView--------
- (void)setDetailModel:(WKRecommendStoryDetailModel *)detailModel{
    _detailModel = detailModel;
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:detailModel.photo_s] placeholderImage:PLACEHOLDER];
    _titleLabel.text = detailModel.text;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _imageV.frame     = self.detailModel.imageFrame;
    _titleLabel.frame = self.detailModel.textFrame;
}


//- (CGFloat)cellHeight
//{
//    CGSize maxSize = CGSizeMake(kScreenWidth-2*10, MAXFLOAT);
//    CGFloat titleTextH = [self.titleLabel.text boundingRectWithSize:maxSize options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
//    
//    return CGRectGetMinY(self.titleLabel.frame) + titleTextH + 10 ;
//}
- (void)awakeFromNib {
      // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
