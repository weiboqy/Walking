//
//  WKSubjectDetailViewController.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSubjectDetailViewController.h"
#import "WKSubjectDetailModel.h"
#import "WKSubjectDetailSectionsModel.h"

@interface WKSubjectDetailViewController ()

@property (nonatomic, strong) NSMutableArray *headArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WKSubjectDetailViewController

- (NSMutableArray *)headArray {
    if (!_headArray) {
        self.headArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _headArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

//  请求数据
- (void)parseData {
    // 显示指示器
    [SVProgressHUD show];
    // ID请求参数
//    WKLog(@"ID = %@",_ID);
    NSString *url = [NSString stringWithFormat:@"http://chanyouji.com/api/articles/%@.json?page=1",_ID];
    [NetWorkRequestManager requestWithType:GET urlString:url parDic:@{} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        WKSubjectDetailModel *detailModel = [[WKSubjectDetailModel alloc] init];
        [detailModel setValuesForKeysWithDictionary:dic];
        
        NSArray *array = dic[@"article_sections"];
        for (NSDictionary *detailDic in array) {
            WKSubjectDetailSectionsModel *detailSectionModel = [[WKSubjectDetailSectionsModel alloc] init];
            [detailSectionModel setValuesForKeysWithDictionary:detailDic];
            detailModel.subjectDetailSectionsModel = detailSectionModel;
            [self.dataArray addObject:detailSectionModel];
        }
         
        [self.headArray addObject:detailModel];
//        WKLog(@"headArray is %@", _headArray);
//        WKLog(@"dataArray is %@", _dataArray);
//        WKLog(@"%ld",_dataArray.count);
        // 取消指示器
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } error:^(NSError *error) {
        // 失败也要取消指示器
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorGlobal;
    
    [self addCustomNagationBar];
    [self parseData];
    
    // Do any additional setup after loading the view from its nib.
}

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

- (void)backClick {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
