//
//  WKWorldDetailCell.m
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKWorldDetailCell.h"

@implementation WKWorldDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        self.clipsToBounds = YES;
        
        _image_urlImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -(kScreenHeight/1.7 -250)/2, kScreenWidth, kScreenHeight/1.7)];
        
        _image_urlImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView  addSubview:_image_urlImageView];
        
        _coverview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
        _coverview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33];
        [self.contentView addSubview:_coverview];
        
        _name_zh_cnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 250 / 2 - 30, kScreenWidth, 30)];
        
        _name_zh_cnLabel.font = [UIFont boldSystemFontOfSize:16];
        
        _name_zh_cnLabel.textAlignment = NSTextAlignmentCenter;
        
        _name_zh_cnLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_name_zh_cnLabel];
        
        _name_enLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 250 / 2 + 30, kScreenWidth, 30)];
        
        _name_enLabel.font = [UIFont systemFontOfSize:14];
        
        _name_enLabel.textAlignment = NSTextAlignmentCenter;
        
        _name_enLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_name_enLabel];
       
    }
    return self;
    
}


- (void)setModel:(WKWorldDetailModel *)model {
    if (_model != model) {
        _model = model;
        self.name_zh_cnLabel.text = [NSString stringWithFormat:@"%@", model.name_zh_cn];
        self.name_enLabel.text = [NSString stringWithFormat:@"%@", model.name_en];
        [self.image_urlImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.image_url]] placeholderImage:PLACEHOLDER];
    }
}

- (CGFloat)cellOffset {
    
    CGRect centerToWindow = [self convertRect:self.bounds toView:self.window];
    CGFloat centerY = CGRectGetMidY(centerToWindow);
    CGPoint windowCenter = self.superview.center;
    
    CGFloat cellOffsetY = centerY - windowCenter.y;
    
    CGFloat offsetDig =  cellOffsetY / self.superview.frame.size.height *2;
    CGFloat offset =  -offsetDig * (kScreenWidth/1.7 - 250)/2;
    
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    
    //    self.titleLabel.transform = transY;
    //    self.littleLabel.transform = transY;
    
    self.image_urlImageView.transform = transY;
    
    return offset;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
