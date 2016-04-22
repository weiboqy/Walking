//
//  WKSubjectViewController.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSubjectViewController.h"
#import "WKSubjectModel.h"

@interface WKSubjectViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIImageView *Image;

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
- (void)parseData {
    // 显示指示器
    [SVProgressHUD show];
    // ID请求参数
//    WKLog(@"%@",_destination_id);

    NSString *url = [NSString stringWithFormat:@"http://chanyouji.com/api/articles.json?destination_id=%@&page=1", _destination_id];
    [[AFHTTPSessionManager manager] GET:url parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 检测请求到的数组
//        WKLog(@"%@",responseObject);
        for (NSDictionary *dic in responseObject) {
            WKSubjectModel *model = [[WKSubjectModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            WKLog(@"url = %@", model.image_url);
            [self.dataArr addObject:model];
        }
        // 测试请求到的数据个数
        WKLog(@"%ld",self.dataArr.count);
        // 取消指示器
        [SVProgressHUD dismiss];
        // 刷新tableView
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主线程刷新UI
            WKSubjectModel *model = _dataArr[0];
            [self.Image sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:PLACEHOLDER];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WKLog(@"faile");
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self.navigationController popViewControllerAnimated:YES];
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
