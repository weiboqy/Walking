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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//  请求数据
- (void)parseData {
//    // 显示指示器
//    [SVProgressHUD show];
//    // ID请求参数
//    WKLog(@"%@",_ID);
//    
//    NSString *url = [NSString stringWithFormat:@"https://chanyouji.com/api/articles.json?destination_id=%@&page=1", _ID];
//    
//    [NetWorkRequestManager requestWithType:GET urlString:url parDic:@{} finish:^(NSData *data) {
//        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        
//    } error:^(NSError *error) {
//        
//    }];
    
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
