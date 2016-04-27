//
//  WKTravelNoteTableViewCell.h
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKTravelNoteModel.h"

@interface WKTravelNoteTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *start_dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *daysLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;

@property (strong, nonatomic) IBOutlet UILabel *likes_count;
@property (strong, nonatomic)WKTravelNoteModel *model;



@end
