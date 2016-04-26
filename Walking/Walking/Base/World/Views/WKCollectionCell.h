//
//  WKCollectionCell.h
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWorldListModel.h"

@interface WKCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *name_zh_cnLabel;
@property (strong, nonatomic) IBOutlet UILabel *name_enLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image_urlImageView;
@property (strong, nonatomic) IBOutlet UILabel *poi_countLabel;
@property (strong, nonatomic)WKWorldListModel *model;

@end
