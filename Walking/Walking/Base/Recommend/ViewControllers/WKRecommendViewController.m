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
#import "WKSearchTableViewController.h"

#import "NetWorkRequestManager.h"
#import "WKRecommendStoryModel.h"
#import "WKRecommendListModel.h"
#import "WKRecommendListUserModel.h"
//检测网络状态
#import "Reachability.h"

#define kStr @"reuse"

@interface WKRecommendViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UITextFieldDelegate>
//轮播图数据 数组
@property (nonatomic, strong) NSMutableArray *viewArray;

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) WKRecommendView *headView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *tableViewDataArray;

@property (nonatomic, strong) NSString *firstStart;
@property (nonatomic, strong) NSString *start;

//collection 刷新数据的 起始位置
@property (nonatomic, assign) NSInteger startLocation;

@property (nonatomic, assign) BOOL isTure;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, assign) NSInteger clickTime;

@property (nonatomic, strong)  UIAlertController *alertC;



@end


@implementation WKRecommendViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)viewArray{
    if (!_viewArray) {
        self.viewArray = [NSMutableArray array];
    }
    return _viewArray;
    
}

- (NSMutableArray *)tableViewDataArray{
    if (!_tableViewDataArray) {
        _tableViewDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _tableViewDataArray;
}

- (void)requestDataForCollectionwithStartLoaction:(NSInteger)startLocation{

    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat: RecommendStoryURL, startLocation] parDic:@{} finish:^(NSData *data) {
       
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
            //取消显示 加载数据框
            if (self.alertC) {
                [self.alertC dismissViewControllerAnimated:YES completion:nil];
            }
        });
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
    }];
}
//请求  轮播图  tableView的数据
- (void)requestDataForList{
    
    [SVProgressHUD show];
    [NetWorkRequestManager requestWithType:GET urlString:RecommendTableViewURL parDic:@{} finish:^(NSData *data) {
        
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        WKLog(@"%@", dicData[@"elements"]);
        _start = dicData[@"next_start"];
        if (self.tableViewDataArray.count>0) {
            [self.tableViewDataArray removeAllObjects];
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
        
        dispatch_once_t once;
        dispatch_once(&once, ^{
            //1 设置头视图轮播图设置(添加文字)
            for (int i = 0; i < 4; i ++) {
                //没有 alloc 操作的还是本身对象
                UIImageView *imageView = self.viewArray[i];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, self.headView.headScrolView.frame.size.height - 50, kScreenWidth - 10, 25)];                ;
                //                label.backgroundColor = [UIColor redColor];
                label.textColor = [UIColor whiteColor];
                label.text = [NSString stringWithFormat:@"%@",[self.tableViewDataArray[i+10] name]];
                [imageView addSubview:label];
                
                [self.viewArray[i] sd_setImageWithURL:[NSURL URLWithString:[self.tableViewDataArray[i+10] cover_image]]];
            }
        });
        
//        WKLog(@"%@", [self.tableViewDataArray[0] ID]);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.listTableView reloadData];
            
            
            [self.listTableView.mj_header endRefreshing];
        });
//        WKLog(@"%@, %ld", _start, self.tableViewDataArray.count);
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败!"];
    }];
    
}
//上拉刷新的请求方法
- (void)requestDataWithStart:(NSString *)next_start{
    
    [SVProgressHUD show];
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:RecommendTableViewMoreURL, _start] parDic:@{} finish:^(NSData *data) {
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
            [self.listTableView.mj_footer endRefreshing];
            
        });
        [SVProgressHUD dismiss];
//        WKLog(@"%@, %ld", _start, self.tableViewDataArray.count);
        
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败!"];
        
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0;
    _start = @"2387313699";
    _startLocation = 0;
    _isTure = YES;
    
    //search 判断点击次数
    _clickTime = 0;
//    self.navigationController.navigationBar.translucent = NO;
    self.title = @"推荐";
    self.view.backgroundColor = ColorGlobal;
#pragma mark --------搜索按钮-------
    UIBarButtonItem *searchBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    [searchBt setTintColor:[UIColor orangeColor]];
    self.navigationItem.rightBarButtonItem = searchBt;

    
#pragma mark ----刷新数据--------
    // 下拉刷新
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 上拉刷新
    self.listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
#pragma mark ---collectionView 刷新---

    [self requestDataForCollectionwithStartLoaction:_startLocation];
    [self requestDataForList];
    [self createListTableView];
    
#pragma mark ---------检测网络状态---------
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
//    Reachability *conn =  [Reachability reachabilityForInternetConnection];
//    [conn startNotifier];
    
    // Do any additional setup after loading the view from its nib.
}
/*
- (void)networkStateChange{
      [self checkNetworkState];
}

- (void)checkNetworkState
 {
     // 1.检测wifi状态
     Reachability *wifi = [Reachability reachabilityForLocalWiFi];

     // 2.检测手机是否能上网络(WIFI\3G\2.5G)
     Reachability *conn = [Reachability reachabilityForInternetConnection];

    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");

     } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
         NSLog(@"使用手机自带网络进行上网");

    } else { // 没有网络
        
         NSLog(@"没有网络");
     }
}
*/
#pragma mark -----设置搜索框-----
//点击搜索 执行
- (void)search{
    
    _clickTime ++;
    WKLog(@"搜索点击次数 %ld", _clickTime);
    if (_clickTime > 1) {
        return;
    }
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _searchView.backgroundColor = [UIColor whiteColor];
    _searchView.alpha = 0.5;
    //添加手势回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_searchView addGestureRecognizer:tap];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 50/667.0*kScreenHeight)];
//    _searchBar.backgroundColor = [UIColor grayColor];
    //    _searchBar.barStyle = UIBarStyleBlackTranslucent;//透明度设置
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    
    [self.view addSubview:_searchView];
    [self.view addSubview:_searchBar];
    
    //    self.navigationItem.titleView = _searchBar;
}
//回收键盘 删除搜索界面
- (void)tap{
    
    [_searchBar  resignFirstResponder];
    [_searchBar  removeFromSuperview];
    [_searchView removeFromSuperview];
    //恢复为初值
    _clickTime = 0;
}
//更多的点击方法
- (void)moreButton{
    //加载更多数据
    _startLocation += 12;
    [self requestDataForCollectionwithStartLoaction:_startLocation];

    //弹出提示 框
    _alertC = [UIAlertController alertControllerWithTitle:@"加载中.." message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [self.navigationController presentViewController:_alertC animated:YES completion:nil];
    
    //3秒执行的方法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WKLog(@"取消显示加载");
        if (_alertC) {
            [_alertC dismissViewControllerAnimated:YES completion:nil];
        }
        
    });
    
    //滚动的  item
    CGPoint p = self.headView.collectionView.contentOffset;
    p = CGPointMake( kScreenWidth-14/375.0 * kScreenWidth + p.x, 0);
    [self.headView.collectionView setContentOffset:p animated:YES];
  

}

- (void)loadNewData{
    // 马上进入刷新状态
    //    [self.listTableView.mj_header beginRefreshing];
    WKLog(@"下啦刷新开始了");
    [self requestDataForList];
}

- (void)loadMoreData{
    WKLog(@"上啦刷新开始了");
    [self requestDataWithStart:_start];
}

#pragma mark --- search--------

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}//任务编辑文

//开始编辑的 执行的方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBa{
    WKLog(@"开始编辑");

}
//结束编辑 执行的方法
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    WKLog(@"结束编辑");
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}//要求
//编辑框文字发生变化 执行的方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    WKLog(@"文本变化了, %@", searchText);
}

//点击搜索按钮 执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    WKLog(@"点击搜索, %@", searchBar.text);
    [searchBar resignFirstResponder];
    
    WKSearchTableViewController *searchVc = [[WKSearchTableViewController alloc] init];
    searchVc.keyStr = searchBar.text;
    [_searchBar removeFromSuperview];
    [_searchView removeFromSuperview];
    _clickTime = 0;
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)listTableViewHeadView{
    
    CGFloat with = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    //590
    self.headView = [[WKRecommendView alloc] initWithFrame:CGRectMake(0, 0, with, 0.884 * height)];//0.884* kScreenHeight
    self.headView.backgroundColor = ColorGlobal;
    self.listTableView.tableHeaderView = self.headView;
    
   //1 设置头视图轮播图(设置占位符)
    for (int i = 0; i < 4; i ++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.headView.headScrolView.bounds];
        imageV.image = [UIImage imageNamed:@"placeholder.jpg"];
        [self.viewArray addObject:imageV];
    }
        //2 设置轮播的图片
    __block WKRecommendViewController *Vc = self;
    self.headView.headScrolView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return Vc.viewArray[pageIndex];
    };
    self.headView.headScrolView.totalPagesCount = 4;
    //3 这个是点击图片的的触发方法
    self.headView.headScrolView.TapActionBlock = ^(NSInteger pageIndex){
//            NSLog(@"点击了：%ld", (long)pageIndex);
        [Vc.searchBar resignFirstResponder];
        
        WKRecommendNotesViewController *notesVc = [[WKRecommendNotesViewController alloc] init];
        notesVc.ID = [Vc.tableViewDataArray[pageIndex] ID];
        [Vc.navigationController pushViewController:notesVc animated:YES];
    };
    //2 moreButton
    [self.headView.moreButton addTarget:self action:@selector(moreButton) forControlEvents:UIControlEventTouchUpInside];
    
    //3 设置collection
    [self.headView.collectionView registerNib:[UINib nibWithNibName:@"WKRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kStr];
    
    self.headView.collectionView.delegate = self;
    self.headView.collectionView.dataSource = self;
    
}
#pragma mark ---collectionView----
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    WKLog(@"%.2f", (kScreenWidth-20-10)/ 2);//0.927
    
    return CGSizeMake((kScreenWidth-14/375.0*kScreenWidth)/ 2, (kScreenWidth-30/375.0*kScreenWidth)/ 2 * 0.927);//160
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
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
    [_searchBar resignFirstResponder];
    
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
    //250
    return (220/667.0) * kScreenHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld", indexPath.row);
    [_searchBar resignFirstResponder];
    WKRecommendNotesViewController *notesVc = [[WKRecommendNotesViewController alloc] init];
    notesVc.ID = [self.tableViewDataArray[indexPath.row] ID];
    notesVc.cover_image = [self.tableViewDataArray[indexPath.row] cover_image];
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
