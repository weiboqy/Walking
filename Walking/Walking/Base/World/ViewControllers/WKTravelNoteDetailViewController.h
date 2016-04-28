//
//  WKTravelNoteDetailViewController.h
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKTravelNoteModel.h"

@interface WKTravelNoteDetailViewController : UIViewController

@property (copy, nonatomic)NSString *ID;

@property (nonatomic, strong)UIView *bgView;

@property (nonatomic, copy)NSString *urlStr;

@property (copy, nonatomic)NSString *image_url;

@property (copy, nonatomic)NSString *name_zn;

@property (strong, nonatomic)WKTravelNoteModel *model ;

@property (nonatomic, strong)UIImageView *imageView1;
@end
