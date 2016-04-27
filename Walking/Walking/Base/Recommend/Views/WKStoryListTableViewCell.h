//
//  WKStoryListTableViewCell.h
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKRecommendStoryDetailModel.h"

@interface WKStoryListTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//@property (nonatomic, assign) CGFloat cellHeight;



@property (nonatomic, strong) WKRecommendStoryDetailModel *detailModel;

@end
