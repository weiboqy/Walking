//
//  WKCategoryViewController.h
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWorldDetailModel.h"

@interface WKCategoryViewController : UIViewController

// 页面模型
@property (strong, nonatomic)WKWorldDetailModel *model;

@property (strong, nonatomic) IBOutlet UILabel *name_zh_cnLabel;
@property (strong, nonatomic) IBOutlet UILabel *name_enLabel;




@end
