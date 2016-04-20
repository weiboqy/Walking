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

@interface WKWorldViewController ()<UIScrollViewDelegate>

/** 根视图 */
@property (strong, nonatomic) IBOutlet UIScrollView *rootScrollView;

/** 国外按钮 */
@property (strong, nonatomic) UIBarButtonItem *foreignItem;

/** 国内按钮 */
@property (strong, nonatomic) UIBarButtonItem *inlandItem;



@end


@implementation WKWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 全局色
    self.view.backgroundColor = ColorGlobal;
    
    // 初始化 控制器
    [self initControllers];
   
    // 创建列表展示
    [self createListView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)createListView {
    
    // 关闭自带的自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rootScrollView.contentSize = CGSizeMake(self.childViewControllers.count * kScreenWidth, 0);
//    self.rootScrollView.contentOffset = CGPointMake(0, 0);
    self.rootScrollView.pagingEnabled = YES;
    self.rootScrollView.delegate = self;
    [self scrollViewDidEndScrollingAnimation:self.rootScrollView];
    
    
    
    // 导航条按钮
    self.foreignItem = [UIBarButtonItem itemWithImage:@"国外1" selectImage:nil target:self action:@selector(foreignClick)];
//    self.foreignItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"国外"] style:UIBarButtonItemStyleDone target:self action:@selector(foreignClick)];
    
    self.inlandItem = [UIBarButtonItem itemWithImage:@"国内1" selectImage:nil target:self action:@selector(inlandClick)];
    self.navigationItem.leftBarButtonItems = @[self.foreignItem, self.inlandItem                                           ];
}

- (void)initControllers {
    WKforeignViewController *foreignVC = [[WKforeignViewController alloc]init];
    [self addChildViewController:foreignVC];
    
    WKInlandViewController *inlandVC = [[WKInlandViewController alloc]init];
    [self addChildViewController:inlandVC];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    WKLog( @"%ld", self.childViewControllers.count);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self scrollViewDidEndScrollingAnimation:self.rootScrollView];
}



- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = self.rootScrollView.contentOffset.x / kScreenWidth;
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = self.rootScrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.width = kScreenWidth;
    vc.view.height = self.rootScrollView.height;
    [self.rootScrollView addSubview:vc.view];
}


#pragma mark --国内\国外按钮的点击方式

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
