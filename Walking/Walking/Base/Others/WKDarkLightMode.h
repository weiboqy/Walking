//
//  WKDarkLightMode.h
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    /** 白天 */
    WKDarkLightModeTypeLight,
    /** 夜晚 */
    WKDarkLightModeTypeDark
} WKDarkLightModeType;

@interface WKDarkLightMode : NSObject

/** 类型 */
@property (nonatomic, assign) WKDarkLightModeType type;

+ (instancetype)defaultManager;

/** 黑夜 */
- (void)darkmode;

/** 白天 */
- (void)lightmode;

@end
