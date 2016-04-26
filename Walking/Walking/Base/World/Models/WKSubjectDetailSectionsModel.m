//
//  WKSubjectDetailSectionsModel.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSubjectDetailSectionsModel.h"

@implementation WKSubjectDetailSectionsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        _Description = value;
    }
}

@end
