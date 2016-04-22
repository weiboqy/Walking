//
//  WKSubjectViewController.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSubjectViewController.h"

@interface WKSubjectViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation WKSubjectViewController

//  懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

//  请求数据
//- (void)parseData {
//    // 显示指示器
//    [SVProgressHUD show];
//    
//    // id请求参数
//    WKLog(@"%@", _ID);
//    
//    NSString *url = [NSString stringWithFormat:@"http://chanyouji.com/api/destinations/%@.json?page=1", _ID];
//    [[AFHTTPSessionManager manager] GET:url parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        for (NSDictionary *dic in responseObject) {
//            WKWorldDetailModel *model = [[WKWorldDetailModel alloc]init];
//            [model setValuesForKeysWithDictionary:dic];
//            [self.dataArr addObject:model];
//            WKLog(@"%@", model.name_zh_cn);
//            //            WKLog(@"%ld", self.dataArr.count);
//        }
//        // 取消指示器
//        [SVProgressHUD dismiss];
//        
//        // 刷新tableView
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        // 失败也取消指示器
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
//    }];
//}

//  请求数据
- (void)parseData {
    // 显示指示器
    [SVProgressHUD show];
    // ID请求参数
    WKLog(@"%@",_ID);
    
    NSString *url = [NSString stringWithFormat:@"https://chanyouji.com/api/articles.json?destination_id=%@&page=1", _ID];
    [[AFHTTPSessionManager manager] GET:url parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WKLog(@"%@",responseObject);
//        for (NSDictionary *dic in responseObject) {
//            <#statements#>
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
