//
//  WKNavigationViewController.m
//  Walking
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKNavigationViewController.h"

@interface WKNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation WKNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 签订侧滑的代理
    self.interactivePopGestureRecognizer.delegate = self;
    
    // Do any additional setup after loading the view.
}

// 侧滑代理实现
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}

 // 这个方法可以拦截所有push进来的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果push进来的不是第一个控制器,才会执行下面的方法
    if (self.childViewControllers.count > 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-10, 0, 70, 30);
        
        // 设置返回按钮的图片
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        
        // 自适应尺寸
        [button sizeToFit];
        [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 将系统返回按钮设置为左按钮(如果不设置左按钮,Button不显示)
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        //push之后 Tabbar消失
        viewController.hidesBottomBarWhenPushed = YES;
    }
   [super pushViewController:viewController animated:animated];
}

- (void)backClick {
    [self popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
