//
//  WKGuideDetailModel.h
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKGuideDetailSectionsModel.h"

@interface WKGuideDetailModel : NSObject


/** 标题 */
@property (copy, nonatomic)NSString *title;

/** 分区信息 */
@property (strong, nonatomic)WKGuideDetailSectionsModel *sectionsModel;


@end
