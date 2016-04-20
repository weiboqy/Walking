//
//  WKNavigtionBar.h
//  Walking
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKNavigtionBar : UINavigationBar

/** 返回按钮 */
@property (strong, nonatomic)UIButton *backButton;

/** 标题 */
@property (strong, nonatomic)UILabel *titleLabel;

/** 标题图片 */
@property (strong, nonatomic)UIImageView *titleImageView;

@end
