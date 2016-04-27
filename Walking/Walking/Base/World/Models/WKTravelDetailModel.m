//
//  WKTravelDetailModel.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKTravelDetailModel.h"

@implementation WKTravelDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        _descriptioN = value;
    }
}

@end
