//
//  WKSearchLastTableViewControllerModel.m
//  Walking
//
//  Created by lanou on 16/4/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSearchLastTableViewControllerModel.h"

@implementation WKSearchLastTableViewControllerModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        _Description = value;
    }
}


@end
