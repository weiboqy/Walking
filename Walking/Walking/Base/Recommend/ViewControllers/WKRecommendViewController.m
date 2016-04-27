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
//刷新位置
@property (nonatomic, strong) NSString *start;


@property (nonatomic, assign) BOOL isTure;
//@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UISearchBar *searchBar;
//@property (nonatomic, strong) UITextField *searchField;

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
//        WKLog(@"%@", [self.tableViewDataArray[0] ID]);
        dispatch_async(dispatch_get_main_queue(), ^{
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
            [self.listTableView reloadData];
            [self.listTableView.mj_header endRefreshing];
        });
//        WKLog(@"%@, %ld", _start, self.tableViewDataArray.count);
        
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
    }];
    
}
//上拉刷新的请求方法
- (void)requestDataWithStart:(NSString *)next_start{
    
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
//        WKLog(@"%@, %ld", _start, self.tableViewDataArray.count);
        
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isTure = YES;
    _index = 0;
    _start = @"2387313699";
    
    self.view.backgroundColor = [UIColor redColor];
    
//    self.title = @"推荐";
//    self.view.backgroundColor = ColorGlobal;
    
#pragma mark -----设置搜索框-----
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
//    _searchBar.backgroundColor = [UIColor clearColor];
//    _searchBar.barStyle = UIBarStyleBlackTranslucent;//透明度设置
//    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor orangeColor];
    self.navigationItem.titleView = _searchBar;
    

#pragma mark ----刷新界面
//    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        WKLog(@"000000");
//    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

#pragma mark ---collectionView 刷新---
//    self.headView.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(collectionHeadRefreshData)];
//    self.headView.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(collectionFooterRefreshData)];
    
    [self requestDataForCollection];
    [self requestDataForList];
    
    [self createListTableView];
    
    // Do any additional setup after loading the view from its nib.
//    

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

//- (void)collectionHeadRefreshData{
//    
//    WKLog(@"collection下啦开始了");
//}
//
//- (void)collectionFooterRefreshData{
//     WKLog(@"collection上啦开始了");
//}

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
    [self.headView.moreButton addTarget:self action:@selector(button) forControlEvents:UIControlEventTouchUpInside];
    
    //3 设置collection
    [self.headView.collectionView registerNib:[UINib nibWithNibName:@"WKRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kStr];
    
    self.headView.collectionView.delegate = self;
    self.headView.collectionView.dataSource = self;
    

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
//    WKLog(@"%.2f", (kScreenWidth-20-10)/ 2);//0.927
    
    return CGSizeMake((kScreenWidth-20-10)/ 2, (kScreenWidth-20-10)/ 2 * 0.927);//160
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
    return (230/667.0) * kScreenHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld", indexPath.row);
    [_searchBar resignFirstResponder];
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
