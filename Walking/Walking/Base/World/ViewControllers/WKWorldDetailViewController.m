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
#import "WKNoGuideCategoryViewController.h"

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
    // 隐藏分割线
    self.tableView.separatorStyle = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKWorldDetailCell class]) bundle:nil] forCellReuseIdentifier:WorldDetailCellID];
    
    [self.view addSubview:self.tableView];
}

- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenHeight, 44)];
    bar.titleLabel.text = _titleName;
    bar.titleLabel.center = CGPointMake(kScreenWidth / 2, 44);
    bar.titleLabel.bounds = CGRectMake(0, 0, 60, 30);
    bar.titleLabel.backgroundColor = [UIColor redColor];
    bar.titleLabel.textAlignment = 2;
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
    [SVProgressHUD showInfoWithStatus:@"正在加载哦~~~"];
    
    // id请求参数
//    WKLog(@"%@", _ID);
    
    NSString *url = [NSString stringWithFormat:@"http://chanyouji.com/api/destinations/%@.json?page=1", _ID];
    [NetWorkRequestManager requestWithType:GET urlString:url parDic:@{} finish:^(NSData *data) {
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dic in dataArr) {
                WKWorldDetailModel *model = [[WKWorldDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
                
//                WKLog(@"%@", model.name_zh_cn);
                //            WKLog(@"%ld", self.dataArr.count);
            }
            // 取消指示器
            [SVProgressHUD dismiss];
            
            // 刷新tableView
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

    } error:^(NSError *error) {
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
    WKWorldDetailModel *model = self.dataArr[indexPath.row];
    
    if ([model.name_zh_cn isEqualToString:@"老挝"] || [model.name_zh_cn isEqualToString:@"朝鲜"] || [model.name_zh_cn isEqualToString:@"西安"] || [model.name_zh_cn isEqualToString:@"青海湖及周边"] || [model.name_zh_cn isEqualToString:@"甘南与兰州"] || [model.name_zh_cn isEqualToString:@"内蒙古"] || [model.name_zh_cn isEqualToString:@"敦煌与嘉峪关"] || [model.name_zh_cn isEqualToString:@"三亚"] || [model.name_zh_cn isEqualToString:@"新疆"] || [model.name_zh_cn isEqualToString:@"哈尔滨"] || [model.name_zh_cn isEqualToString:@"青岛"] || [model.name_zh_cn isEqualToString:@"洛阳"] || [model.name_zh_cn isEqualToString:@"桂林"] || [model.name_zh_cn isEqualToString:@"凤凰与张家界"] || [model.name_zh_cn isEqualToString:@"婺源"]) {
        WKNoGuideCategoryViewController *noGuideCategoryVC = [[WKNoGuideCategoryViewController alloc]init];
        noGuideCategoryVC.model = model;
        noGuideCategoryVC.ID = model.ID;
        [self.navigationController pushViewController:noGuideCategoryVC animated:YES];
    } else {
        WKCategoryViewController *categoryVC = [[WKCategoryViewController alloc]init];
        categoryVC.model = model;
        categoryVC.ID = model.ID;
        [self.navigationController pushViewController:categoryVC animated:YES];
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
