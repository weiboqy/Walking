//
//  WKGuideDetailSectionsModel.h
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKGuideDetailPhotoModel.h"
#import "WKGuideUserModel.h"

@interface WKGuideDetailSectionsModel : NSObject

/** 标题 */
@property (copy, nonatomic)NSString *title;
/** 描述 */
@property (copy, nonatomic)NSString *descriptioN;
/** 游玩时间 */
@property (copy, nonatomic)NSString *travel_date;
/** 图片模型 */
@property (strong, nonatomic)WKGuideDetailPhotoModel *photoModel;
/** 作者信息 */
@property (strong, nonatomic)WKGuideUserModel *userModel;

@end
