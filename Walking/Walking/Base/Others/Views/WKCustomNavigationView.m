//
//  WKCustomNavigationView.m
//  Walking
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKCustomNavigationView.h"

@implementation WKCustomNavigationView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _navigationBar = [[UIView alloc]initWithFrame:frame];
        
        _imageView = [[UIImageView alloc]initWithFrame:self.navigationBar.frame];
        
        _visualEffectView1 = [[UIVisualEffectView alloc]initWithFrame:_imageView.frame];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _visualEffectView1.effect = blur;
        [_imageView addSubview:_visualEffectView1];
        [_navigationBar addSubview:_imageView];
        
        
        _navigationBar1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 64)];
        _navigationBar1.backgroundColor  = [UIColor clearColor];
        _back = [UIButton buttonWithType:UIButtonTypeCustom];
        [_back setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        _share = [UIButton buttonWithType:UIButtonTypeCustom];
        [_share setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_navigationBar1 addSubview:_share];
//        self.back.frame = CGRectMake(10, 27, 50, 30);
        [_navigationBar1 addSubview:_back];
        
        
        _back1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_back1 setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        _share1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_share1 setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_navigationBar addSubview:_share1];
//        self.back1.frame = CGRectMake(10, 27, 50, 30);
        [_navigationBar addSubview:_back1];
        
        [_navigationBar1 addSubview:_navigationBar];
        
        [self addSubview:_navigationBar1];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}


@end
