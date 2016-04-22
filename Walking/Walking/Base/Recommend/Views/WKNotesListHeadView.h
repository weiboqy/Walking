//
//  WKNotesListHeadView.h
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKNotesListHeadView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *daysLabel;
@property (strong, nonatomic) IBOutlet UILabel *moterLabel;
@property (strong, nonatomic) IBOutlet UILabel *motersLabel;

@property (strong, nonatomic) IBOutlet UILabel *loveLabel;
@property (strong, nonatomic) IBOutlet UILabel *lovesLabel;


- (void)handleImage;


@end
