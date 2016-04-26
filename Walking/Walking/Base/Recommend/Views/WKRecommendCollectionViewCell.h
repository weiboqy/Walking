//
//  WKRecommendCollectionViewCell.h
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKRecommendStoryModel.h"

@interface WKRecommendCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic, strong) WKRecommendStoryModel *storyModel;
@property (strong, nonatomic) IBOutlet UIImageView *backImageV;



@end
