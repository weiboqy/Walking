//
//  WKWorldViewController.m
//  Walking
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKWorldViewController.h"

@interface WKWorldViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *rootScrollView;

@end

@implementation WKWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)createListView {
    
    self.rootScrollView.contentSize = CGSizeMake(kScreenWidth, 0);
    self.rootScrollView.contentOffset = CGPointMake(0, 0);
    
    UIView *firstView = [[UIView alloc]init];
    firstView.frame = CGRectMake(100, 100, 20, 20);
    firstView.backgroundColor = [UIColor redColor];
    
    UIView *secondView = [[UIView alloc]init];
    secondView.frame = CGRectMake(kScreenWidth + 100, 100, 20, 20);
    secondView.backgroundColor = [UIColor orangeColor];
    
    [self.rootScrollView addSubview:firstView];
    [self.rootScrollView addSubview:secondView];
    
    
    
    self.navigationItem.leftBarButtonItems = @[
                                               [UIBarButtonItem itemWithImage:@"" selectImage:@"" target:self action:@selector(foreignClick)],
                                               [UIBarButtonItem itemWithImage:@"" selectImage:@"" target:self action:@selector(inlandClick)]
                                               ];
}

- (void)foreignClick {
    WKLogFun;
}

- (void)inlandClick {
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
