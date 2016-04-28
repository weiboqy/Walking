//
//  WKGuideViewController.h
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKGuideViewController : UIViewController


// 请求参数
@property (nonatomic, copy) NSString *ID;

/** 图片 */
@property (copy, nonatomic)NSString *image_url;

/** 标题 */
@property (copy, nonatomic)NSString *name_zn;


@end
