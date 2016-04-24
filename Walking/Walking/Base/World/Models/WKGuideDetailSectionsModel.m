//
//  WKGuideDetailSectionsModel.m
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKGuideDetailSectionsModel.h"

@implementation WKGuideDetailSectionsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        _descriptioN = value;
    }
}

@end
