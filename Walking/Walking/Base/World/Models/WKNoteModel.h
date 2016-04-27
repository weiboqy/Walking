//
//  WKNoteModel.h
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKTravelPhotoModel.h"

@interface WKNoteModel : NSObject

/** 用户评论详情 */
@property (copy, nonatomic)NSString *descriptioN;

@property (strong, nonatomic)WKTravelPhotoModel *photoModel;

@end
