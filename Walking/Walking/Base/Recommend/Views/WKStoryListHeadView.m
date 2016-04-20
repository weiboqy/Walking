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
        self.icon.layer.cornerRadius = 30;
        self.icon.layer.masksToBounds = YES;
    }
    return self;
}

- (void)initializeData{
    self.icon.layer.cornerRadius = 30;
    self.icon.layer.masksToBounds = YES;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
