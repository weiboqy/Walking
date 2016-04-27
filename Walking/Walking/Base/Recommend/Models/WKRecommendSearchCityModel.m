//
//  WKRecommendSearchCityModel.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendSearchCityModel.h"

@implementation WKRecommendSearchCityModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}


@end
