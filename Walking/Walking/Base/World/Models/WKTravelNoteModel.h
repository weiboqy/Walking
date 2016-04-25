//
//  WKTravelNoteModel.h
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKTravelNoteUserModel.h"
@interface WKTravelNoteModel : NSObject

/** ID */
@property (copy, nonatomic)NSString *ID;
/** 标题 */
@property (copy, nonatomic)NSString *name;
/** 起始日期 */
@property (copy, nonatomic)NSString *start_date;
/** 结束时间 */
@property (copy, nonatomic)NSString *end_date;
/** 天数 */
@property (copy, nonatomic)NSString *days;
/** 图片数量 */
@property (copy, nonatomic)NSString *photos_count;
/** 封面图片 */
@property (copy, nonatomic)NSString *front_cover_photo_url;

/** 用户信息 */
@property (strong, nonatomic)WKTravelNoteUserModel *userModel;


@end
