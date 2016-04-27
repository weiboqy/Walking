//
//  WKRecommendStoryViewController.h
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat (^CellHeightBlock)();
@interface WKRecommendStoryViewController : UIViewController

@property (nonatomic, copy) NSString *spot_id;
@property (nonatomic, strong) NSString *imageURL;

@property (nonatomic, copy) CellHeightBlock cellHeightBlock;

@end
