//
//  WKSubjectImageTableViewCell.h
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKSubjectDetailSectionsModel.h"

@interface WKSubjectImageTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString *urlStr;
@property (strong, nonatomic) UIView *bgView;
/** 缩放视图层 */
@property (nonatomic, strong)UIImageView *imageView1;

@property (nonatomic, strong) WKSubjectDetailSectionsModel *model;

@end
