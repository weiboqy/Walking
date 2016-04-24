//
//  WKGuideOverviewCell.h
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGuideDetailSectionsModel.h"
@interface WKGuideOverviewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image_urlImageView;

@property (strong, nonatomic)WKGuideDetailSectionsModel *model;

@end
