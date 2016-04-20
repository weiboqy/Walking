//
//  WKforeignViewController.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKforeignViewController.h"
#import "WKCollectionCell.h"

@interface WKforeignViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/** 界面列表 */
@property (strong, nonatomic) UICollectionView *foreignCollectView;

@end

// collectionView的标识符
static NSString * const foreignCollectViewCellID = @"WKForeignCollectViewCellID";
@implementation WKforeignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化 视图
    [self stetupSubView];
}
- (void)stetupSubView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 每个item直接的间距
    layout.minimumInteritemSpacing = 5;
    // 每行之间的间距
    layout.minimumLineSpacing = 5;
    //设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    
    // 关闭自带的自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.foreignCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    self.foreignCollectView.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:232 / 255.0 blue:232 / 255.0 alpha:1.0];
    self.foreignCollectView.dataSource = self;
    self.foreignCollectView.delegate = self;
    
    [self.foreignCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([WKCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:foreignCollectViewCellID];
    [self.view addSubview:self.foreignCollectView];
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
    
    WKCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:foreignCollectViewCellID forIndexPath:indexPath];
    return cell;
    
    return nil;
}


@end
