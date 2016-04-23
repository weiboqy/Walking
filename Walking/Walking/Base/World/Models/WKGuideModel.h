//
//  WKGuideModel.h
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKGuideDetailModel.h"

@interface WKGuideModel : NSObject

/** 标题 */
@property (copy, nonatomic)NSString *title;

@property (strong, nonatomic)WKGuideDetailModel *detailModel;


@end
