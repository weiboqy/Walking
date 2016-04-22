//
//  WKWorldListModel.m
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKWorldListModel.h"

@implementation WKWorldListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString: @"id"]) {
        _ID = value;
    }
}

@end
