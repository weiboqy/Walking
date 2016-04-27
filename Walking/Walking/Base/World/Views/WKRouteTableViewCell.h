//
//  WKRouteTableViewCell.h
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKRouteModel.h"

@interface WKRouteTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayslabel;
@property (strong, nonatomic) IBOutlet UILabel *plan_nodes_countsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image_urlImage;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;

@property (strong, nonatomic) WKRouteModel *model;

@end
