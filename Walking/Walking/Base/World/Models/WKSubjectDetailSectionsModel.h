//
//  WKSubjectDetailSectionsModel.h
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKSubjectDetailSectionsModel : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 图片 */
@property (nonatomic, copy) NSString *image_url;
/** 描述 */
@property (nonatomic, copy) NSString *Description;
/** 图片宽度 */
@property (nonatomic, assign) NSInteger image_width;
/** 图片高度 */
@property (nonatomic, assign) NSInteger image_height;
/** 图片的frame */
@property (nonatomic, assign) CGRect imageFrame;
/** 文本的frame */
@property (nonatomic, assign) CGRect textFrame;


/** 额外的属性 **/
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 文字的高度 */
//@property (nonatomic, assign) CGFloat textHeight;

@end
