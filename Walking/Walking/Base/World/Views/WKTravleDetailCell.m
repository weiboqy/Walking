//
//  WKTravleDetailCell.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKTravleDetailCell.h"

@implementation WKTravleDetailCell


//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([WKTravleDetailCell class])]) {
//        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        _headerImageView.layer.contentsScale = 10;
//        _headerImageView.layer.masksToBounds = YES;
//        [self.contentView addSubview:_headerImageView];
//        
//        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _nameLabel.textColor = [UIColor blackColor];
//        [self.contentView addSubview:_nameLabel];
//        
//        _starImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        [self.contentView addSubview:_starImageView];
//        
//        _star1ImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        [self.contentView addSubview:_star1ImageView];
//        
//        _star2ImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        [self.contentView addSubview:_star2ImageView];
//        
//        _star3ImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        [self.contentView addSubview:_star3ImageView];
//        
//        _star4ImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        [self.contentView addSubview:_star4ImageView];
//        
//        _textImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        [self.contentView addSubview:_textImageView];
//        
//        _textsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.contentView addSubview:_textsLabel];
//        
//        _siteImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [self.contentView addSubview:_siteImageView];
//        
//        _siteNameButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [self.contentView addSubview:_siteNameButton];
//        
//        
//    }
//    return self;
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    _headerImageView.frame = CGRectMake(10, 10, 50, 50);
//    _nameLabel.frame = CGRectMake(15, 12, 80, 20);
//    _starImageView.frame = CGRectMake(15, 37, 5, 5);
//    _star1ImageView.frame = CGRectMake(CGRectGetMaxX(_starImageView.frame) + 2, 37, 5, 5);
//    _star2ImageView.frame = CGRectMake(CGRectGetMaxX(_star1ImageView.frame) + 2, 37, 5, 5);
//    _star3ImageView.frame = CGRectMake(CGRectGetMaxX(_star2ImageView.frame) + 2, 37, 5, 5);
//    _star4ImageView.frame = CGRectMake(CGRectGetMaxX(_star3ImageView.frame) + 2, 37, 5, 5);
//    _textImageView.frame = CGRectMake(10, 70, kScreenWidth - 20, 200);
//    _textsLabel.frame = CGRectMake(10, CGRectGetMaxY(_textImageView.frame) + 10, kScreenWidth - 20, 100);
//    
//    _siteImageView.frame = CGRectMake(10, CGRectGetMaxY(_textsLabel.frame) + 10, 10, 20);
//    _siteNameButton.frame = CGRectMake(CGRectGetMaxX(_siteImageView.frame) + 5, CGRectGetMaxY(_textsLabel.frame) + 10 , 100, 20);
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
