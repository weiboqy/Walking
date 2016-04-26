//
//  WKWorldViewController.m
//  Walking
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKWorldViewController.h"
#import "WKCollectionCell.h"
#import "WKforeignViewController.h"
#import "WKInlandViewController.h"
#import "WKWorldListModel.h"
#import "WKTabBarViewController.h"


@interface WKWorldViewController ()<UIScrollViewDelegate>

/** 根视图 */
@property (strong, nonatomic) IBOutlet UIScrollView *rootScrollView;

/** 国外按钮 */
@property (strong, nonatomic) UIButton *foreignButton;

/** 国内按钮 */
@property (strong, nonatomic) UIButton *inlandButton;

@end

@implementation WKWorldViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 全局色
    self.view.backgroundColor = ColorGlobal;
    
    // 初始化 控制器
    [self ReloadControllers];
    
    // 创建列表展示
    [self createListView];
    
    //隐藏系统自带的NavigationBar
    [self.navigationController setNavigationBarHidden:YES];
    
    // 自定义导航条
    [self addCustomNagationBar];
    // Do any additional setup after loading the view from its nib.
    
    }

- (void)createListView {
    // 关闭自带的自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rootScrollView.contentSize = CGSizeMake(self.childViewControllers.count * kScreenWidth, 0);
    self.rootScrollView.backgroundColor = ColorGlobal;
    self.rootScrollView.pagingEnabled = YES;
    self.rootScrollView.delegate = self;
    
    // 手动加载结束动画
    [self scrollViewDidEndScrollingAnimation:self.rootScrollView];
    
}

// 初始化 子控制器
- (void)ReloadControllers {
    WKforeignViewController *foreignVC = [[WKforeignViewController alloc]init];
    [self addChildViewController:foreignVC];
    WKInlandViewController *inlandVC = [[WKInlandViewController alloc]init];
    [self addChildViewController:inlandVC];
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    WKLog( @"%ld", self.childViewControllers.count);
//}

// scrollView结束减速的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.rootScrollView];
    NSInteger index = self.rootScrollView.contentOffset.x / kScreenWidth;
    if (index == 0) {
        [_foreignButton setImage:[UIImage imageNamed:@"国外"] forState:UIControlStateNormal];
        [_inlandButton setImage:[UIImage imageNamed:@"国内1"] forState:UIControlStateNormal];
    }
    if (index == 1) {
        [_foreignButton setImage:[UIImage imageNamed:@"国外1"] forState:UIControlStateNormal];
        [_inlandButton setImage:[UIImage imageNamed:@"国内"] forState:UIControlStateNormal];
    }
}

// scrollView滑动结束动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = self.rootScrollView.contentOffset.x / kScreenWidth;
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = self.rootScrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.width = kScreenWidth;
    vc.view.height = self.rootScrollView.height ;
    [self.rootScrollView addSubview:vc.view];
}

// 自定义导航条
- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenHeight, 44)];
    
    // 国外按钮
    _foreignButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _foreignButton.frame = CGRectMake(10, 10, 50, 30);
    [_foreignButton setImage:[UIImage imageNamed:@"国外"] forState:UIControlStateNormal];
    [_foreignButton addTarget:self action:@selector(foreignClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 国内anniu
    _inlandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _inlandButton.frame = CGRectMake(CGRectGetMaxX(_foreignButton.frame) + 5, 10, 50, 30);
    [_inlandButton setImage:[UIImage imageNamed:@"国内1"] forState:UIControlStateNormal];
    [_inlandButton addTarget:self action:@selector(inlandClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加
    [bar addSubview:_foreignButton];
    [bar addSubview:_inlandButton];
    [self.view addSubview:bar];
  
}

#pragma mark --国内\国外按钮的点击方式

- (void)foreignClick {
//    WKLogFun;
    _foreignButton.selected = YES;
    [_foreignButton setImage:[UIImage imageNamed:@"国外"] forState:UIControlStateNormal];
    [_inlandButton setImage:[UIImage imageNamed:@"国内1"] forState:UIControlStateNormal];
    self.rootScrollView.contentOffset = CGPointMake(0, 0);
}

- (void)inlandClick {
//    WKLogFun;
    _inlandButton.selected = YES;
    [_foreignButton setImage:[UIImage imageNamed:@"国外1"] forState:UIControlStateNormal];
    [_inlandButton setImage:[UIImage imageNamed:@"国内"] forState:UIControlStateNormal];
    self.rootScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
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
