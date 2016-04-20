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
        self.backgroundColor = [UIColor whiteColor];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self addSubview:_backButton];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _titleLabel.bounds = CGRectMake(0, 0, 100, self.frame.size.height);
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_titleLabel];
        
        
        _titleImageView = [[UIImageView alloc]init];
        _titleImageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _titleImageView.bounds = CGRectMake(0, 0, 96, 35);
        [self addSubview:_titleImageView];
        
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
