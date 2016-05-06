//
//  RegisterViewController.h
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^sendBlock)(NSString *, NSString *);

@interface RegisterViewController : UIViewController

@property (nonatomic, copy) sendBlock block;

@end
