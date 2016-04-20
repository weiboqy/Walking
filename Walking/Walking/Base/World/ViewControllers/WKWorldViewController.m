//
//  WKWorldViewController.m
//  Walking
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKWorldViewController.h"
#import "WKCollectionCell.h"

@interface WKWorldViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/** 根视图 */
@property (strong, nonatomic) IBOutlet UIScrollView *rootScrollView;

/** 界面列表 */
@property (strong, nonatomic) UICollectionView *foreignCollectView;
@property (strong, nonatomic) UICollectionView *inlandCollectView;


@end

// collectionView的标识符
static NSString * const WKWorldCollectViewCellID = @"WKWorldCollectViewCellID";

@implementation WKWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 全局色
    self.view.backgroundColor = ColorGlobal;
    
    // 创建列表展示
    [self createListView];
    // Do any additional setup after loading the view from its nib.
}

- (void)createListView {
    
    self.rootScrollView.contentSize = CGSizeMake(kScreenWidth, 0);
    self.rootScrollView.contentOffset = CGPointMake(0, 0);
    self.rootScrollView.pagingEnabled = YES;
    
    
    // 创建collectView
    [self createCollectView];
    
    self.navigationItem.leftBarButtonItems = @[
                                               [UIBarButtonItem itemWithImage:@"国外1" selectImage:@"国外" target:self action:@selector(foreignClick)],
                                               [UIBarButtonItem itemWithImage:@"国内1" selectImage:@"国内" target:self action:@selector(inlandClick)]
                                               ];
}

- (void)createCollectView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 每个item直接的间距
    layout.minimumInteritemSpacing = 5;
    // 每行之间的间距
    layout.minimumLineSpacing = 5;
    
    //设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    
    // 关闭自带的自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.foreignCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, 375, kScreenHeight - 44) collectionViewLayout:layout];
    self.foreignCollectView.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:232 / 255.0 blue:232 / 255.0 alpha:1.0];
    self.foreignCollectView.dataSource = self;
    self.foreignCollectView.delegate = self;
    
//    self.inlandCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(kScreenWidth, 44, self.rootScrollView.frame.size.width / 2, kScreenHeight - 44) collectionViewLayout:layout];
//    self.foreignCollectView.dataSource = self;
//    self.foreignCollectView.delegate = self;
    
    // 注册cell
    [self.foreignCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([WKCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:WKWorldCollectViewCellID];
//    [self.inlandCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([WKCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:WKWorldCollectViewCellID];
    
    [self.rootScrollView addSubview:self.foreignCollectView];
//    [self.rootScrollView addSubview:self.inlandCollectView];
}

#pragma mark --国内\国外按钮的点击方式

- (void)foreignClick {
    WKLogFun;
}

- (void)inlandClick {
    WKLogFun;
}

// 每个item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 35) / 2, 200);
}
#pragma mark ---UICollectViewDelegate\UICollectViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WKCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WKWorldCollectViewCellID forIndexPath:indexPath];
    return cell;
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
