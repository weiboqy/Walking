//
//  WKRecommendNotesDetailModel.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendNotesDetailModel.h"

@implementation WKRecommendNotesDetailModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
 
    if ([key isEqualToString:@"day"]) {
        _DAY = value;
    }
}

@end
