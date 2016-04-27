//
//  WKRouteDetailViewController.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRouteDetailViewController.h"
#import "WKRouteModel.h"
#import "WKRouteDetailCell.h"

@interface WKRouteDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

// 数据源
@property (strong, nonatomic)NSMutableArray *dataArr;
// 头视图数据源
@property (nonatomic, strong)NSMutableArray *headerDataArr;

@property (copy, nonatomic)NSString *name;

// 列表
@property (nonatomic, strong)UITableView *tableView;


@end

static NSString * const TableViewCellID = @"TableViewCellID";

@implementation WKRouteDetailViewController

#pragma mark  ----懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableArray *)headerDataArr {
    if (!_headerDataArr) {
        _headerDataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _headerDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色
    self.view.backgroundColor = ColorGlobal;
    
    // 创建TableView
    [self setupSubViews];
    
    // 加载数据
    [self loadData];
    
    // 自定义导航条
    [self addCustomNagationBar];
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
- (void)loadData {
    //
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://chanyouji.com/api/plans/%@.json?page=1", _ID] parDic:@{} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        WKLog(@"%@", dataDic);
        WKRouteModel *model = [[WKRouteModel alloc]init];
        [model setValuesForKeysWithDictionary:dataDic];
        [_headerDataArr addObject:model];
        for (NSDictionary *planDic in dataDic[@"plan_days"]) {
            for (NSDictionary *dic in planDic[@"plan_nodes"]) {
                NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithCapacity:0];
                WKRoutePlanModel *planModel = [[WKRoutePlanModel alloc]init];
                [planModel setValuesForKeysWithDictionary:dic];
                NSDictionary *nameDic = dic[@"destination"];
                NSString *name = nameDic[@"name_zh_cn"];
                WKLog(@"entry_naem = %@", planModel.entry_name);
                WKLog(@"name = %@", name);
                WKLog(@"tips = %@", planModel.tips);
                _name = name;
                [mDic setValue:planModel forKey:name];
                [self.dataArr addObject:planModel];
            }
        }
        WKLog(@"count = %ld", self.dataArr.count);
//        for (NSDictionary *dic in self.dataArr) {
//            WKLog(@"%@ ",dic);
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        
    }];
}

- (void)setupSubViews {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKRouteDetailCell class]) bundle:nil] forCellReuseIdentifier:TableViewCellID];
    [self.view addSubview:self.tableView];
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataArr.count;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.dataArr.count == 0) {
//        return 0;
//    }else {
//        
//        NSDictionary *dic = self.dataArr[section];
//        WKLog(@"=====%ld", [dic allKeys].count);
//        return [dic allKeys].count;
//    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKRouteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellID forIndexPath:indexPath];
//    NSDictionary *dic = self.dataArr[indexPath.section];
//    WKRoutePlanModel *model = dic[dic.allKeys[indexPath.row]];
    WKRoutePlanModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

//// 指定分区头显示的内容
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 0:{
//            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//            lable.text = [NSString stringWithFormat:@"DAY:%ld ", section];
//            return lable;
//        }
//            break;
//        case 1:{
//            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//            lable.text = [NSString stringWithFormat:@"DAY:%ld", section];
//            return lable;
//        }
//            break;
//        case 2:{
//            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//            lable.text = [NSString stringWithFormat:@"DAY:%ld", section ];
//            return lable;
//        }
//            break;
//            
//        default:{
//            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//            lable.text = [NSString stringWithFormat:@"DAY:%ld", section];
//            return lable;
//        }
//            break;
//    }
//}
//
//// 分区头高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 30;
//}

@end
