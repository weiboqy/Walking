//
//  WKrecomendSearchDetailModel.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecomendSearchDetailModel.h"

@implementation WKRecomendSearchDetailModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        _descriptionS = value;
    }
}

@end
