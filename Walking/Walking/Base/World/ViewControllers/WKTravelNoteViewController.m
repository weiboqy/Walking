//
//  WKTravelNoteViewController.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKTravelNoteViewController.h"
#import "WKTravelNoteModel.h"

@interface WKTravelNoteViewController ()

/** 数据源 */
@property (strong, nonatomic)NSMutableArray *dataArr;

@end

@implementation WKTravelNoteViewController

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
}
// 自定义导航条
- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenHeight, 44)];
    bar.titleLabel.text = [NSString stringWithFormat:@"%@游记", _name_zn];
    bar.titleLabel.center = CGPointMake(kScreenWidth / 2, 44);
    bar.titleLabel.bounds = CGRectMake(0, 0, 80, 30);
    bar.titleLabel.textAlignment = NSTextAlignmentCenter;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(18, 10, 70, 30);
    // 设置返回按钮的图片
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    // 自适应尺寸
    [button sizeToFit];
    
    // 添加方法
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
    WKLog(@"%@", _ID);
    // 显示指示器
    [SVProgressHUD showInfoWithStatus:@"正在加载哦~~~"];
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://chanyouji.com/api/destinations/trips/%@.json?month=0&page=1", _ID] parDic:@{} finish:^(NSData *data) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        WKLog(@"%@", arr);
        for (NSDictionary *dic in arr) {
            WKTravelNoteModel *model = [[WKTravelNoteModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            NSDictionary *userDic = dic[@"user"];
            WKTravelNoteUserModel *userModel = [[WKTravelNoteUserModel alloc]init];
            [userModel setValuesForKeysWithDictionary:userDic];
            model.userModel = userModel;
            [self.dataArr addObject:model];
            WKLog(@"%@", model.name);
        }
        // 取消指示器
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
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
