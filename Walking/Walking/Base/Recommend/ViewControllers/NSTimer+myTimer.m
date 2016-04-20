//
//  NSTimer+myTimer.m
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "NSTimer+myTimer.h"

@implementation NSTimer (myTimer)

//这些方法都要加 判断计时器是否在执行计时状态

//计时器暂停
-(void)pauseTimer{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}
//计时器继续计时
-(void)resumeTimer{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}
//计时器在多少秒以后开始继续计时
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}


@end
