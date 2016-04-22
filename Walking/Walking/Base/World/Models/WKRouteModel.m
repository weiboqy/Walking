//
//  WKRouteModel.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRouteModel.h"

@implementation WKRouteModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        _descriptioN = value;
    }
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}

@end
