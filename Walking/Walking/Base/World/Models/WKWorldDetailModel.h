//
//  WKWorldDetailModel.h
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKWorldDetailModel : NSObject

/** id */
@property (copy, nonatomic)NSString *ID;

/** 图片 */
@property (copy, nonatomic)NSString *image_url;

/** 地点 */
@property (copy, nonatomic)NSString *name_zh_cn;
/** 地点英文 */
@property (copy, nonatomic)NSString *name_en;

@end
