//
//  WKGuideImpressionCell.h
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGuideDetailSectionsModel.h"

@interface WKGuideImpressionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *descriptionLable;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *travel_dataLabel;

@property (strong, nonatomic)WKGuideDetailSectionsModel *model;
@end
