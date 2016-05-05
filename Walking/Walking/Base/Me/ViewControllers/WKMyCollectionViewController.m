//
//  WKMyCollectionViewController.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKMyCollectionViewController.h"
#import "WKCollectionTableViewCell.h"
#import "WKRecommendDB.h"
#import "WKCollectModel.h"
#import "WKRecommendStoryViewController.h"
#import "WKRecommendNotesViewController.h"

@interface WKMyCollectionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArr;

@end

static NSString * const TableViewCellID = @"TableCellID";

@implementation WKMyCollectionViewController

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSArray alloc]init];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.tableView reloadData];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.translucent = NO;
    // 标题
    self.navigationItem.title = @"我的收藏";
    // 加载数据
    [self loadData];
    // 创建TableView
    [self setupTableView];
    
    // Do any additional setup after loading the view from its nib.
}

// 加载数据
- (void)loadData {
    WKCollectModel *model = [[WKCollectModel alloc]init];
    self.dataArr = [[[WKRecommendDB alloc]init] getAllDataWithCollectModel:model];
    WKLog(@"%ld", self.dataArr.count);
}

// 创建TableView
- (void)setupTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKCollectionTableViewCell class]) bundle:nil] forCellReuseIdentifier:TableViewCellID];
    [self.view addSubview:self.tableView];
}

#pragma mark -----TableViewDataSource、 TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellID forIndexPath:indexPath];
    WKCollectModel *model = self.dataArr[indexPath.row];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.imageURL]] placeholderImage:PLACEHOLDER];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WKCollectModel *model = self.dataArr[indexPath.row];
//    NSArray *arr = [[[WKRecommendDB alloc]init] findWithID:model.ID];
    if ([model.type isEqualToString:@"story"]) {
        WKRecommendStoryViewController *storyVC = [[WKRecommendStoryViewController alloc]init];
        storyVC.imageURL = model.imageURL;
        storyVC.spot_id = model.ID;
        [self.navigationController pushViewController:storyVC animated:nil];
    }else {
        WKRecommendNotesViewController *noteVC = [[WKRecommendNotesViewController alloc]init];
        noteVC.ID = model.ID;
        noteVC.cover_image = model.imageURL;
        [self.navigationController pushViewController:noteVC animated:YES];
    }
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
