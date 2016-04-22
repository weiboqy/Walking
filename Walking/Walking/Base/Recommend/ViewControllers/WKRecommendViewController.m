//
//  WKRecommendViewController.m
//  Walking
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendViewController.h"
#import "WKListTableViewCell.h"
#import "WKRecommendView.h"
#import "WKRecommendCollectionViewCell.h"
#import "WKRecommendNotesViewController.h"
#import "WKRecommendStoryViewController.h"

#import "NetWorkRequestManager.h"
#import "WKRecommendStoryModel.h"
#import "WKRecommendListModel.h"
#import "WKRecommendListUserModel.h"
#define kStr @"reuse"

@interface WKRecommendViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) WKRecommendView *headView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *tableViewDataArray;

//刷新位置
@property (nonatomic, strong) NSString *start;

@end


@implementation WKRecommendViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)tableViewDataArray{
    if (!_tableViewDataArray) {
        _tableViewDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _tableViewDataArray;
}

- (void)requestDataForCollection{
    
    [NetWorkRequestManager requestWithType:GET urlString:RecommendStoryURL parDic:@{} finish:^(NSData *data) {
       
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@", dicData);
        
        NSArray *array = dicData[@"data"][@"hot_spot_list"];
        for (NSDictionary *dic in array) {
            WKRecommendStoryModel *storyModel = [[WKRecommendStoryModel alloc] init];
            [storyModel setValuesForKeysWithDictionary:dic];
//            WKLog(@"%@", dic[@"spot_id"]);
            //复制 跳转页面的 id 参数
            storyModel.spot_id = dic[@"spot_id"];
            [storyModel setValuesForKeysWithDictionary:dic[@"user"]];
            [self.dataArray addObject:storyModel];
        }
        
//        WKLog(@"%@, %ld", [self.dataArray[0] spot_id], self.dataArray.count);
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.headView.collectionView reloadData];
//            //刷新 UI 来实现改变 偏移量 现实的效果不同
//            [self.headView.collectionView setContentOffset:CGPointMake(kScreenWidth * 2, 0)];
        });
        
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
    }];
}
//请求  轮播图  tableView的数据
- (void)requestDataForList{
    
    
    [NetWorkRequestManager requestWithType:GET urlString:RecommendTableViewURL parDic:@{} finish:^(NSData *data) {
        
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        WKLog(@"%@", dicData[@"elements"]);
        _start = dicData[@"next_start"];
        
        for (NSDictionary *dic in dicData[@"elements"]) {
            WKRecommendListModel *listModel = [[WKRecommendListModel alloc] init];
            WKRecommendListUserModel *userModel = [[WKRecommendListUserModel alloc] init];
            if ([dic[@"desc"] isEqualToString:@"热门游记"]) {
                NSArray *arr = dic[@"data"];
                NSDictionary *dicS = arr[0];
                [listModel setValuesForKeysWithDictionary:dicS];
            
                [userModel setValuesForKeysWithDictionary:dicS[@"user"] ];
                listModel.userMosel = userModel;
                [self.tableViewDataArray addObject:listModel];
            }
        }
//        WKLog(@"%@", [self.tableViewDataArray[0] ID]);
        //1 设置头视图轮播图
        NSMutableArray *viewArray = [@[] mutableCopy];
        for (int i = 0; i < 4; i ++) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.headView.headScrolView.bounds];
            imageV.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1.0];
            [imageV sd_setImageWithURL:[NSURL URLWithString:[self.tableViewDataArray[i + 10] cover_image]]];
            [viewArray addObject:imageV];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //2 设置轮播的图片
//            __weak WKRecommendViewController *VC = self;
            self.headView.headScrolView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                
                return viewArray[pageIndex];
            };
            
            [self.listTableView reloadData];
        });
        
//        WKLog(@"%@, %ld", _start, self.tableViewDataArray.count);
        
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
    }];
    
}
//上拉刷新的请求方法
- (void)requestDataWithStart:(NSString *)next_start{
    
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:RecommendTableViewMoreURL, _start] parDic:@{next_start : _start} finish:^(NSData *data) {
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//       WKLog(@"%@", dicData[@"elements"]);
        //改变 刷新的 开始位置
        if (dicData[@"next_start"]) {
            _start = dicData[@"next_start"];
        }
        
        for (NSDictionary *dic in dicData[@"elements"]) {
            WKRecommendListModel *listModel = [[WKRecommendListModel alloc] init];
            WKRecommendListUserModel *userModel = [[WKRecommendListUserModel alloc] init];
            if ([dic[@"desc"] isEqualToString:@"热门游记"]) {
                NSArray *arr = dic[@"data"];
                NSDictionary *dicS = arr[0];
                [listModel setValuesForKeysWithDictionary:dicS];
                
                [userModel setValuesForKeysWithDictionary:dicS[@"user"] ];
                listModel.userMosel = userModel;
                [self.tableViewDataArray addObject:listModel];
            }
        }        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableView reloadData];
            
        });
//        WKLog(@"%@, %ld", _start, self.tableViewDataArray.count);
        
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"推荐";
    self.view.backgroundColor = ColorGlobal;
    
    UIBarButtonItem *searchBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = searchBt;
    
    [self requestDataForCollection];
    [self requestDataForList];
    
    [self createListTableView];
    _index = 0;
    _start = @"2387313699";

    

    
    // Do any additional setup after loading the view from its nib.
//    

}

- (void)search{
    WKLog(@"search!!!");
    
    //测试使用 刷新 新的数据
//    [self requestDataWithStart:_start];
    
    
    
    
}

- (void)listTableViewHeadView{
    
    CGFloat with = [[UIScreen mainScreen] bounds].size.width;
    self.headView = [[WKRecommendView alloc] initWithFrame:CGRectMake(0, 0, with, 570)];
    self.headView.backgroundColor = ColorGlobal;
    self.listTableView.tableHeaderView = self.headView;
    
   //1 设置头视图轮播图
//    NSMutableArray *viewArray = [@[] mutableCopy];
//    for (int i = 0; i < 4; i ++) {
//        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.headView.headScrolView.bounds];
//            imageV.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1.0];
//        [viewArray addObject:imageV];
//    }
//        //2 设置轮播的图片
//    __weak WKRecommendViewController *VC = self;
//    self.headView.headScrolView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
////        if (VC.tableViewDataArray) {
////            for (int i = 11; i < 12; i ++) {
////                [viewArray addObject:VC.tableViewDataArray[i]];
////            }
////        }        
//        
//        return viewArray[pageIndex];
//    };
    self.headView.headScrolView.totalPagesCount = 4;
    
    //3 这个是点击图片的的触发方法
    self.headView.headScrolView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了：%ld", (long)pageIndex);
    };
    //2 moreButton
    [self.headView.moreButton addTarget:self action:@selector(button) forControlEvents:UIControlEventTouchUpInside];
    
    //3 设置collection
    [self.headView.collectionView registerNib:[UINib nibWithNibName:@"WKRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kStr];
    
    self.headView.collectionView.delegate = self;
    self.headView.collectionView.dataSource = self;
    
    
    
// [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2500 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
   
}
//更多的点击方法
- (void)button{
//    NSLog(@"moreButton");
    if (self.headView.collectionView.contentOffset.x  > self.headView.collectionView.contentSize.width - kScreenWidth + 20) {
         [self.headView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        return;
    }
    //滚动的  item
    CGPoint p = self.headView.collectionView.contentOffset;
    p = CGPointMake((kScreenWidth-20 + 10) + p.x, 0);
    [self.headView.collectionView setContentOffset:p animated:YES];
}

#pragma mark ---collectionView----
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-20-10)/ 2, 160);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WKRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStr forIndexPath:indexPath];
    
    cell.storyModel = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld, %ld", indexPath.section, indexPath.row);
    
    WKRecommendStoryViewController *storyVc = [[WKRecommendStoryViewController alloc] init];
    //把我图片 传给 跳转的视图控制器
    storyVc.imageURL = [self.dataArray[indexPath.row] cover_image];
    //网络请求 参数
    storyVc.spot_id = [self.dataArray[indexPath.row] spot_id];
    [self.navigationController pushViewController:storyVc animated:YES];
    
}

- (void)createListTableView{
    
    self.listTableView.delegate   = self;
    self.listTableView.dataSource = self;
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"WKListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    [self listTableViewHeadView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WKListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.listModel = self.tableViewDataArray[indexPath.row];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", indexPath.row);
    
    WKRecommendNotesViewController *notesVc = [[WKRecommendNotesViewController alloc] init];
    notesVc.ID = [self.tableViewDataArray[indexPath.row] ID];
    [self.navigationController pushViewController:notesVc animated:YES];
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
