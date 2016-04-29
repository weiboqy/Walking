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
    
    _urlStr = model.image_url;
    _cellImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_cellImageView addGestureRecognizer:tap];
}

// 图片点击手势
- (void)tapClick {
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    imageView.bounds = CGRectMake(0, 0, 0, 0);
    dispatch_async(dispatch_get_main_queue(), ^{
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _urlStr]] placeholderImage:PLACEHOLDER];
    });
    
    UIPinchGestureRecognizer  *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchClick:)];
    [imageView addGestureRecognizer:pinch];
    imageView.userInteractionEnabled = YES;
    UIView *bgView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [bgView addGestureRecognizer:tap];
    [UIView animateWithDuration:.25 animations:^{
        imageView.bounds = CGRectMake(0, 0, kScreenWidth, 400);
    }];
    [bgView addSubview:imageView];
    _bgView = bgView;
    _imageView1 = imageView;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
}
- (void)pinchClick:(UIPinchGestureRecognizer *)pinch {
    //获取要进行缩放的视图
    _imageView1 = (UIImageView *)pinch.view;
    _imageView1.transform = CGAffineTransformScale(_imageView1.transform, pinch.scale, pinch.scale);  //以imageV.transform为基础
    pinch.scale = 1;
}

- (void)tapAction {
    [_bgView removeFromSuperview];
}

//  重写布局方法
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _cellImageView.frame = self.model.imageFrame;
    _cellTextLabel.frame = self.model.textFrame;
}

@end
