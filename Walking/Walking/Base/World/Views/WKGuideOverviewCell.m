//
//  WKGuideOverviewCell.m
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKGuideOverviewCell.h"
#import "AppDelegate.h"

@implementation WKGuideOverviewCell

- (void)setModel:(WKGuideDetailSectionsModel *)model {
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    _descriptionLabel.text = [NSString stringWithFormat:@"%@", model.descriptioN];
    [_image_urlImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.photoModel.image_url]] placeholderImage:PLACEHOLDER];
    _image_urlImageView.contentMode = UIViewContentModeScaleAspectFill;
    _image_urlImageView.clipsToBounds = YES;
    _image_urlImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _urlStr = model.photoModel.image_url;
    _image_urlImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_image_urlImageView addGestureRecognizer:tap];
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
