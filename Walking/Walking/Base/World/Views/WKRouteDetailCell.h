//
//  WKRouteDetailCell.h
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKRoutePlanModel.h"

@interface WKRouteDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *entry_nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image_urlImageView;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;

@property (nonatomic, strong)WKRoutePlanModel *model;




@end
