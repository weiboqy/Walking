//
//  WKGuideDetailSectionsModel.h
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKGuideDetailPhotoModel.h"

@interface WKGuideDetailSectionsModel : NSObject

/** 标题 */
@property (copy, nonatomic)NSString *title;
/** 图片模型 */
@property (strong, nonatomic)WKGuideDetailPhotoModel *photoModel;

@end
