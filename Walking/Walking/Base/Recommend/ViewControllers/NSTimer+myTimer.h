//
//  NSTimer+myTimer.h
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (myTimer)


// 暂停
- (void)pauseTimer;
// 继续
- (void)resumeTimer;
// 在多少秒以后继续
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;


@end
