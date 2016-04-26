//
//  WKSubjectImageTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSubjectImageTableViewCell.h"

@interface WKSubjectImageTableViewCell ()

/** cell 的图片 */
@property (nonatomic, strong) UIImageView *cellImageView;
/** cell 的文本 */
@property (nonatomic, strong) UILabel *cellTextLabel;

@end

@implementation WKSubjectImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _cellTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _cellTextLabel.font = [UIFont systemFontOfSize:15.0];
        _cellTextLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_cellImageView];
        [self.contentView addSubview:_cellTextLabel];
    }
    return self;
}

//  给模型赋值
- (void)setModel:(WKSubjectDetailSectionsModel *)model {
    _model = model;
    
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:PLACEHOLDER];
    _cellTextLabel.text = model.Description;
}

//  重写布局方法
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _cellImageView.frame = self.model.imageFrame;
    _cellTextLabel.frame = self.model.textFrame;
}

@end
