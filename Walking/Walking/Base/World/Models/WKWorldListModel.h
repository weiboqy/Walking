//
//  WKWorldListModel.h
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKWorldListModel : NSObject

/** id */
@property (copy, nonatomic)NSString *ID;
/** 图片 */
@property (copy, nonatomic)NSString *image_url;

/** 地点 */
@property (copy, nonatomic)NSString *name_zh_cn;
/** 地点英文 */
@property (copy, nonatomic)NSString *name_en;
/** 旅游地点个数 */
@property (assign, nonatomic)NSInteger poi_count;



@end
