//
//  WKTravelDetailModel.h
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKNoteModel.h"

@interface WKTravelDetailModel : NSObject

/** 第几天 */
@property (copy, nonatomic)NSString *day;
/** 描述 */
@property (copy, nonatomic)NSString *descriptioN;
/** 点赞 */
@property (copy, nonatomic)NSString *col;
/** score */
@property (copy, nonatomic)NSString *score;
/** 作者姓名 */
@property (copy, nonatomic)NSString *entry_name;
/** 评论 */
@property (copy, nonatomic)NSString *comment;

@property (strong, nonatomic)WKNoteModel *noteModel;





@end
