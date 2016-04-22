//
//  WKRouteModel.h
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKRouteModel : NSObject

/** id */
@property (copy, nonatomic)NSString *ID;
/** 标题 */
@property (copy, nonatomic)NSString *name;
/** 描述 */
@property (copy, nonatomic)NSString *descriptioN;
/** 天数 */
@property (copy, nonatomic)NSString *plan_days_count;
/** 旅行地 */
@property (copy, nonatomic)NSString *plan_nodes_counts;
/** 图片 */
@property (copy, nonatomic)NSString *image_url;




@end
