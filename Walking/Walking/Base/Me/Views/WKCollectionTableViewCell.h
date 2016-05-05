//
//  WKCollectionTableViewCell.h
//  Walking
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCollectionTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *bgView;

@end
