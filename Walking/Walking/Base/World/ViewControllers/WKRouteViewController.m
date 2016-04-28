//
//  WKRouteViewController.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRouteViewController.h"
#import "WKRouteModel.h"
#import "WKRouteDetailViewController.h"
#import "WKRouteTableViewCell.h"

@interface WKRouteViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic)UITableView *tableView;

@end

static NSString * const TableViewCellID = @"TableViewCellID";

@implementation WKRouteViewController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorGlobal;
    
    [self setupSubViews];
    
    // 自定义导航条
    [self addCustomNagationBar];
    
    // 加载数据
    [self parseData];
    
   
}
- (void)setupSubViews {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKRouteTableViewCell class]) bundle:nil] forCellReuseIdentifier:TableViewCellID];
    [self.view addSubview:self.tableView];
}
// 自定义导航条
- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenHeight, 44)];
    bar.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(18, 10, 70, 30);
    // 设置返回按钮的图片
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    // 自适应尺寸
    [button sizeToFit];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:button];
    [self.view addSubview:bar];
}
// 返回按钮
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

// 加载数据
- (void)parseData {
    // 显示指示器
    [SVProgressHUD showInfoWithStatus:@"正在加载哦~~~"];
    WKLog(@"%@", _ID);
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://chanyouji.com/api/destinations/plans/%@.json?page=1", _ID] parDic:@{} finish:^(NSData *data) {
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in dataArr) {
            WKRouteModel *model = [[WKRouteModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            WKLog(@"plan = counts = %@", model.plan_nodes_counts);
            [self.dataArr addObject:model];
        }
        // 取消指示器
        [SVProgressHUD dismiss];
//        WKLog(@"%ld", self.dataArr.count);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        // 取消指示器
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
   
}

#pragma mark  ---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKRouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WKRouteDetailViewController *detailVC = [[WKRouteDetailViewController alloc]init];
    WKRouteModel *model = self.dataArr[indexPath.row];
    detailVC.ID = model.ID;
    detailVC.image_url = model.image_url;
    detailVC.name_zn = model.name;
    detailVC.days = model.plan_days_count;
    detailVC.plan_nodes_counts = model.plan_nodes_counts;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
