//
//  WKWorldDetailCell.h
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWorldDetailModel.h"

@interface WKWorldDetailCell : UITableViewCell

//@property (strong, nonatomic) IBOutlet UILabel *name_zh_cnLabel;
//@property (strong, nonatomic) IBOutlet UILabel *name_enLabel;
//@property (strong, nonatomic) IBOutlet UIImageView *image_urlImageView;

/** 背景图 */
@property (strong, nonatomic) UIImageView *image_urlImageView;
/** 中文名 */
@property (strong, nonatomic) UILabel *name_zh_cnLabel;
/** 英文名 */
@property (strong, nonatomic) UILabel *name_enLabel;
/** 半透明视图 */
@property (strong, nonatomic) UIView *coverview;
/** 世界详情WKWorldDetailModel模型 */
@property (strong, nonatomic)WKWorldDetailModel *model;

- (CGFloat)cellOffset;

@end
