//
//  WKInlandViewController.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKInlandViewController.h"
#import "WKCollectionCell.h"
#import "WKWorldListModel.h"
#import "WKWorldDetailViewController.h"

@interface WKInlandViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/** 界面列表 */
@property (strong, nonatomic) UICollectionView *inlandCollectView;
@property (strong, nonatomic)NSMutableArray *dataArr;

@end

// collectionView的标识符
static NSString * const inlandCollectViewCellID = @"WKInlandCollectViewCellID";

@implementation WKInlandViewController

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorGlobal;
    // 关闭自带的自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 加载数据
    [self praseData];
    
    // 初始化 视图
    [self setupSubView];
}

#pragma mark  ---加载数据
- (void)praseData {
    [[AFHTTPSessionManager manager] GET:@"http://chanyouji.com/api/destinations.json?page=1" parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (int i = 3; i < 5; i ++) {
            NSDictionary *dic = responseObject[i];
            for (NSDictionary *dataDic in dic[@"destinations"]) {
                WKWorldListModel *listModel = [[WKWorldListModel alloc]init];
                [listModel setValuesForKeysWithDictionary:dataDic];
                [self.dataArr addObject:listModel];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.inlandCollectView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WKLog(@"faile");
    }];
    
}

- (void)setupSubView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 每个item直接的间距
    layout.minimumInteritemSpacing = 10;
    // 每行之间的间距
    layout.minimumLineSpacing = 10;
    //设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    
    // 关闭自带的自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.inlandCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    self.inlandCollectView.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:232 / 255.0 blue:232 / 255.0 alpha:1.0];
    self.inlandCollectView.dataSource = self;
    self.inlandCollectView.delegate = self;
    
    [self.inlandCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([WKCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:inlandCollectViewCellID];
    
    [self.view addSubview:self.inlandCollectView];
}
// 每个item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 30) / 2, 180);
}

#pragma mark ---UICollectViewDelegate\UICollectViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WKCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inlandCollectViewCellID forIndexPath:indexPath];
    WKWorldListModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WKWorldDetailViewController *detailVC = [[WKWorldDetailViewController alloc]init];
    
    WKWorldListModel *model = self.dataArr[indexPath.row];
    detailVC.ID = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//- collect

@end
