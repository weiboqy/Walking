//
//  WKRecommendSearchModel.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendSearchModel.h"

@implementation WKRecommendSearchModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}


@end
