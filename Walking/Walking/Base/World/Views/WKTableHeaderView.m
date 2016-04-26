//
//  WKTableHeaderView.m
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKTableHeaderView.h"

@implementation WKTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return  self;
}

- (void)setupSubViews {
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    [self.contentView addSubview:self.textLabel];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 1)];
    view.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:view];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
