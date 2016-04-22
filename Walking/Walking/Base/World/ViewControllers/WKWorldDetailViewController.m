//
//  WKWorldDetailViewController.m
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKWorldDetailViewController.h"
#import "WKWorldDetailModel.h"
#import "WKWorldDetailCell.h"
#import "WKCategoryViewController.h"

@interface WKWorldDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArr;

@end

static NSString * const WorldDetailCellID = @"WorldDetailCellID";

@implementation WKWorldDetailViewController

#pragma mark ---懒加载
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.5];
    self.view.backgroundColor = ColorGlobal;
    
    [self addCustomNagationBar];
    
    [self parseData];
    
    // 
    [self createListView];
    // Do any additional setup after loading the view.
}

- (void)createListView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKWorldDetailCell class]) bundle:nil] forCellReuseIdentifier:WorldDetailCellID];
    
    [self.view addSubview:self.tableView];
}

- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenHeight, 44)];
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

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)parseData {
    // 显示指示器
    [SVProgressHUD show];
    
    // id请求参数
    WKLog(@"%@", _ID);
    
    NSString *url = [NSString stringWithFormat:@"http://chanyouji.com/api/destinations/%@.json?page=1", _ID];
    [[AFHTTPSessionManager manager] GET:url parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            for (NSDictionary *dic in responseObject) {
                WKWorldDetailModel *model = [[WKWorldDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
                WKLog(@"%@", model.name_zh_cn);
//            WKLog(@"%ld", self.dataArr.count);
        }
        // 取消指示器
        [SVProgressHUD dismiss];
        
        // 刷新tableView
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败也取消指示器
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}


#pragma mark ----UITabvleView代理
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKWorldDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:WorldDetailCellID forIndexPath:indexPath];
    WKWorldDetailModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WKCategoryViewController *categoryVC = [[WKCategoryViewController alloc]init];
    WKWorldDetailModel *model = self.dataArr[indexPath.row];
    categoryVC.model = model;
    [self.navigationController pushViewController:categoryVC animated:YES];
    
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
