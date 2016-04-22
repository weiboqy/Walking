//
//  WKTabBarViewController.m
//  Walking
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKTabBarViewController.h"
#import "WKNavigationViewController.h"
#import "WKRecommendViewController.h"
#import "WKWorldViewController.h"
#import "WKMeViewController.h"

@interface WKTabBarViewController ()

@end

@implementation WKTabBarViewController

// 程序运行期间只会 执行一次
+ (void)initialize {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    
    UITabBarItem *item = [UITabBarItem appearance];  // 当有appearance的时候 就表明可以配置全局性的东西
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

// 初始化 子视图
- (void)createChildView:(UIViewController *)viewController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:image];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    WKNavigationViewController *naVC = [[WKNavigationViewController alloc]initWithRootViewController:viewController];
    
    // 添加子视图
    [self addChildViewController:naVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 判断夜间模式 */
    if ([WKDarkLightMode defaultManager].type == 1) {//如果为夜间模式
        [[WKDarkLightMode defaultManager] lightmode];
        [[WKDarkLightMode defaultManager] darkmode];
//                CGRect frame = CGRectMake(0, 0, kScreenWidth, 44);
//                UIView *v = [[UIView alloc] initWithFrame:frame];
//                [v setBackgroundColor:[[UIColor alloc] initWithRed:70.0/255.0
//                                                             green:65.0/255.0
//                                                              blue:62.0/255.0
//                                                             alpha:1]];
//                WKTabBarViewController *vc = (WKTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                //        [vc.tabBar addSubview:v];
//                //        [vc.tabBar insertSubview:v atIndex:0];
//                [vc.tabBar insertSubview:v atIndex:self.view.subviews.count];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [UIView animateWithDuration:0.1 animations:^{
        // 推荐模块
        WKRecommendViewController *recommendVC = [[WKRecommendViewController alloc]init];
        [self createChildView:recommendVC title:@"推荐" image:@"写字" selectedImage:nil];
        // 时间模块
        WKWorldViewController *worldVC = [[WKWorldViewController alloc]init];
        [self createChildView:worldVC title:@"世界" image:@"写字" selectedImage:nil];
        // 我 模块
        WKMeViewController *meVC = [[WKMeViewController alloc]init];
        [self createChildView:meVC title:@"我" image:@"写字" selectedImage:nil];
    }];

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
