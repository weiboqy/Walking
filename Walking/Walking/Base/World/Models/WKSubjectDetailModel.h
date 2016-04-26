//
//  WKSubjectDetailModel.h
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKSubjectDetailSectionsModel.h"

@interface WKSubjectDetailModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *name;
/** 副标题 */
@property (nonatomic, copy) NSString *title;
/** 头视图背景图 */
@property (nonatomic, copy) NSString *image_url;
/** 文章分节 */
@property (nonatomic, strong) WKSubjectDetailSectionsModel *subjectDetailSectionsModel;

@end
