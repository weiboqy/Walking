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
#import "WKSubjectImageTableViewCell.h"

@interface WKSubjectDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *headArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *label;

@end

static NSString * const ImageCellID = @"imageCell";

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
//    [SVProgressHUD show];
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
            WKLog(@"%@",detailSectionModel.image_url);
        }
         
        [self.headArray addObject:detailModel];
//        WKLog(@"headArray is %@", _headArray);
        WKLog(@"dataArray is %@", _dataArray);
//        WKLog(@"%ld",_dataArray.count);
//        WKLog(@"_headArray.count = %ld",_headArray.count);
        // 取消指示器
//        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            //  头视图
            [self createHeadeView];
            //  自定义NagationBar
            [self addCustomNagationBar];
            
            // 刷新控件
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        // 失败也要取消指示器
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //  数据请求
    [self parseData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    // 创建tableView
    [self setupTableView];
}

/**
 *  创建tableView
 */
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[WKSubjectImageTableViewCell class]forCellReuseIdentifier:ImageCellID];
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

- (void)backClick{
//    WKLogFun;
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 创建头视图
- (void)createHeadeView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 自适应文本
    WKSubjectDetailSectionsModel *detailModel = _dataArray[0];
    CGSize maxSize = [detailModel.Description boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil].size;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, (624.0 / 1024) * kScreenWidth * 1.8 - 200 + 10, maxSize.width, maxSize.height)];
    self.label.text = detailModel.Description;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:15.0];
    
    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (624.0 / 1024) * kScreenWidth * 1.8 - 200 + 30 + maxSize.height)];
    bgView.backgroundColor = [UIColor whiteColor];
    // 请求图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, kScreenWidth, (624.0 / 1024) * kScreenWidth * 1.8)];
    WKSubjectDetailModel *model = _headArray[0];
//    WKLog(@"%@",model);
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    [bgView addSubview:imageView];
    
    [bgView addSubview:_label];
    
    // UIView
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (624.0 / 1024) * kScreenWidth * 1.8 - 200 + 20 + maxSize.height, maxSize.width, 2)];
//    [lineView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    lineView.layer.cornerRadius = 2;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:lineView];
    
    self.tableView.tableHeaderView = bgView;
                                                              
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -<UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKSubjectDetailSectionsModel *model = self.dataArray[indexPath.row + 1];
    return model.cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKSubjectImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageCellID];
    cell.model = self.dataArray[indexPath.row + 1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
