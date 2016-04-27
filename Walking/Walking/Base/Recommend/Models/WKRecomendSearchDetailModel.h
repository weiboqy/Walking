//
//  WKrecomendSearchDetailModel.h
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKRecomendSearchDetailModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *descriptionS;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSNumber *visited_count;


@end
