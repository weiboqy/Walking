//
//  WKWorldDetailCell.h
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWorldDetailModel.h"

@interface WKWorldDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name_zh_cnLabel;
@property (strong, nonatomic) IBOutlet UILabel *name_enLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image_urlImageView;
@property (strong, nonatomic)WKWorldDetailModel *model;

@end
