//
//  WKStoryListHeadView.h
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKStoryListHeadView : UIView


@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UIImageView *icon;



- (instancetype)initWithFrame:(CGRect)frame;

- (void)initializeData;

@end
