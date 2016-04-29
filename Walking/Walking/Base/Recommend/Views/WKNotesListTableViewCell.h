//
//  WKNotesListTableViewCell.h
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKRecommendNotesDetailModel.h"

@interface WKNotesListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dayTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageC;


@property (nonatomic, strong) WKRecommendNotesDetailModel *detailModel;









@end
