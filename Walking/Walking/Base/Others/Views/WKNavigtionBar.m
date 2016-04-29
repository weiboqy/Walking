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
//        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.width, 64)];
//        bgView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [bgView addSubview:_backButton];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [_titleLabel sizeToFit];
        [bgView addSubview:_titleLabel];
        
        _titleImageView = [[UIImageView alloc]init];
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
