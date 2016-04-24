//
//  WKNavigtionBar.m
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKNavigtionBar.h"

@implementation WKNavigtionBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.width, 64)];
        bgView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [bgView addSubview:_backButton];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.center = CGPointMake(self.frame.size.width / 2 - 120, self.frame.size.height / 2 + 30);
//        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.bounds = CGRectMake(0, 0, 100, self.frame.size.height);
        _titleLabel.font = [UIFont systemFontOfSize:18];
//        _titleLabel.frame = CGRectMake(self.width / 2 - 180, 32, 100, 20);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
        [bgView addSubview:_titleLabel];
        
        
        _titleImageView = [[UIImageView alloc]init];
        _titleImageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _titleImageView.bounds = CGRectMake(0, 0, 96, 35);
        [bgView addSubview:_titleImageView];
        
        [self addSubview:bgView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //当前视图边界和边界变化的大小
    [_titleImageView sizeToFit];
    [_titleLabel sizeToFit];
}

@end
