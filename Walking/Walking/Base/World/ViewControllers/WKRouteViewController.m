//
//  WKRouteViewController.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRouteViewController.h"
#import "WKRouteModel.h"

@interface WKRouteViewController ()

@property (strong, nonatomic)NSMutableArray *dataArr;

@end

@implementation WKRouteViewController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义导航条
    [self addCustomNagationBar];
    
    // 加载数据
    [self parseData];
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
            [self.dataArr addObject:model];
        }
        // 取消指示器
        [SVProgressHUD dismiss];
        WKLog(@"%ld", self.dataArr.count);
    } error:^(NSError *error) {
        // 取消指示器
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
   
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
