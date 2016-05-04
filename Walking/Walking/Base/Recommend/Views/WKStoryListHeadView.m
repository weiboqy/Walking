//
//  WKStoryListHeadView.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKStoryListHeadView.h"

@implementation WKStoryListHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.icon.layer.cornerRadius = 30/375.0 * kScreenWidth;
        self.icon.layer.masksToBounds = YES;
        self.view.layer.cornerRadius = 5/375.0 * kScreenWidth;
        self.view.layer.masksToBounds = YES;
    }
    return self;
}

- (void)initializeData{
    
    self.icon.layer.cornerRadius = 28/375.0 * kScreenWidth;
    self.icon.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 5/375.0 * kScreenWidth;
    self.view.layer.masksToBounds = YES;
//    CGPoint p = CGPointMake(0, .0);
//    self.TLabel.frame.origin = p;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
