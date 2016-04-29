//
//  WKWelcomeViewController.m
//  Walking
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKWelcomeViewController.h"
#import "WKTabBarViewController.h"

@interface WKWelcomeViewController ()

@end

@implementation WKWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 1; i < 34; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome－%d（被拖移）.tiff",i]];
        [mArr addObject:image];
    }
    imageView.animationImages = mArr;
    imageView.animationRepeatCount = 0;
    imageView.animationDuration = 5;
    [imageView startAnimating];
    [self.view addSubview:imageView];
    
    UIView *screenView = [[UIView alloc]init];
    screenView.frame = imageView.frame;
    screenView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:screenView];
    
    UILabel *label = [[UILabel alloc]init];
    label.center = CGPointMake(kScreenWidth - 100, kScreenHeight - 50);
    label.bounds = CGRectMake(0, 0, 80, 30);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"即刻进入";
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(CGRectGetMaxX(label.frame) + 5, CGRectGetMidY(label.frame) - 12, 30, 30);
    image.image = [UIImage imageNamed:@"右箭头"];
    [screenView addSubview:image];
    [screenView addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(235, 602, 110, 30);
    [button addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
    [screenView addSubview:button];
    
    WKLog(@"%@", NSStringFromCGRect(label.frame));
    
    // Do any additional setup after loading the view.
}

- (void)tapClick {
    WKTabBarViewController *tabBarVC = [[WKTabBarViewController alloc] init];
    tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:tabBarVC animated:YES completion:nil];
    WKLogFun;
    
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
