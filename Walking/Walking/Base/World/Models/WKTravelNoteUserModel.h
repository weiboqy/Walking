//
//  WKTravelNoteUserModel.h
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKTravelNoteUserModel : NSObject

/** 用户id */
@property (copy, nonatomic)NSString *ID;
/** 用户名 */
@property (copy, nonatomic)NSString *name;
/** 用户头像 */
@property (copy, nonatomic)NSString *image;

@end
