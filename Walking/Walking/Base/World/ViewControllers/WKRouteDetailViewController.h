//
//  WKRouteDetailViewController.h
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKRouteModel.h"

@interface WKRouteDetailViewController : UIViewController

@property (copy, nonatomic)NSString *ID;
@property (copy, nonatomic)NSString *image_url;
/** 标题 */
@property (copy, nonatomic)NSString *name_zn;
@property (copy, nonatomic)NSString *plan_nodes_counts;
@property (copy, nonatomic)NSString *days;


@property (strong, nonatomic)WKRouteModel *model;

@property (nonatomic, strong)UIImageView *imageView;

@end
