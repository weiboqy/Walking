//
//  WKGuideViewController.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKGuideViewController.h"
#import "WKGuideModel.h"
#import "WKGuideOverviewCell.h"
#import "WKGuideImpressionCell.h"
#import "WKTableHeaderView.h"

@interface WKGuideViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 数据源 */
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic)NSMutableArray *dataArr1;

/**列表展示*/
@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic)WKNavigtionBar *bar;

/** 记录总偏移量 */
@property (assign, nonatomic)CGFloat bgViewOffsetY;
@property (strong, nonatomic)UIView *bgView;

@end

// TableViewCell标识符
static NSString * const OverViewCellID = @"OverViewCellID";
static NSString * const ImpressionCellID = @"ImpressionCellID";

// TableViewHeader标识符
static NSString * const tableHeaderID = @"tableHeaderID";

@implementation WKGuideViewController

#pragma mark ---- 懒加载
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableArray *)dataArr1 {
    if (_dataArr1 == nil) {
        _dataArr1 = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置全局色背景
    self.view.backgroundColor = ColorGlobal;
    
    // 加载数据
    [self parseData];
    
    [self createListView];
    
    // 自定义导航条
    [self addCustomNagationBar];
}

// 自定义导航条
- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenHeight, 44)];
    bar.titleLabel.text = [NSString stringWithFormat:@"%@游玩指南", _name_zn];
    bar.titleLabel.center = CGPointMake(kScreenWidth / 2, 44);
    bar.titleLabel.bounds = CGRectMake(0, 0, 120, 30);
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
    _bar = bar;
    [self.view addSubview:_bar];
}

// 返回按钮
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

// 加载数据
- (void)parseData {
    // 显示指示器
    [SVProgressHUD showInfoWithStatus:@"正在加载哦~~~"];
    WKLog(@"ID = %@", _ID);
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://chanyouji.com/api/wiki/destinations/%@.json?page=1", _ID] parDic:@{} finish:^(NSData *data) {
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = dataArr[0];
        NSDictionary *dataDic = dic[@"pages"][0];
        WKGuideModel *model = [[WKGuideModel alloc]init];
        [model setValuesForKeysWithDictionary:dataDic];
        
        for (NSDictionary *detailDic in dataDic[@"children"]) {
            WKGuideDetailModel *detailModel = [[WKGuideDetailModel alloc]init];
            [detailModel setValuesForKeysWithDictionary:detailDic];
            for (NSDictionary *detailDic1 in detailDic[@"sections"]) {
                WKGuideDetailSectionsModel *sectionsModel = [[WKGuideDetailSectionsModel alloc]init];
                [sectionsModel setValuesForKeysWithDictionary:detailDic1];
                
                NSDictionary *userDic = detailDic1[@"user"];
                WKGuideUserModel *userModel = [[WKGuideUserModel alloc]init];
                [userModel setValuesForKeysWithDictionary:userDic];
                sectionsModel.userModel = userModel;
                
                NSArray *arr = detailDic1[@"photos"];
                WKLog(@"count - %ld", arr.count);
                if (arr.count == 0) {
                    // 空返回
                }
                if (arr.count == 1) {
                    NSDictionary *detailDic2 = detailDic1[@"photos"][0];
                    WKGuideDetailPhotoModel *photoModel = [[WKGuideDetailPhotoModel alloc]init];
                    [photoModel setValuesForKeysWithDictionary:detailDic2];
                    sectionsModel.photoModel = photoModel;
                }
                if (arr.count > 1) {
                    for (NSDictionary *detailDic2 in detailDic1[@"photos"]) {
                        WKGuideDetailPhotoModel *photoModel = [[WKGuideDetailPhotoModel alloc]init];
                        [photoModel setValuesForKeysWithDictionary:detailDic2];
                        sectionsModel.photoModel = photoModel;
                    }
                }
                detailModel.sectionsModel = sectionsModel;
                [self.dataArr addObject:sectionsModel];
                
                [self.dataArr1 addObject:detailModel];
                WKLog(@"titleSECTION = %@", model.detailModel.sectionsModel.title);
                
                model.detailModel = detailModel;
                //                [self.dataArr addObject:model];
                //                NSMutableDictionary *dataMutableDic = [[NSMutableDictionary alloc]initWithCapacity:0];
                //                [dataMutableDic setObject:detailModel forKey:detailModel.title];
                //                [self.dataArr addObject:dataMutableDic];
            }
            WKLog(@"title = %@", model.title);
            WKLog(@"title1 = %@", model.detailModel.title);
            WKLog(@"title2 = %@", model.detailModel.sectionsModel.title);
            WKLog(@"des  = %@", model.detailModel.sectionsModel.descriptioN);
            WKLog(@"imageUrl = %@", model.detailModel.sectionsModel.photoModel.image_url);
        }
        WKLog(@"count ARR = %@", self.dataArr);
        // 取消指示器
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        // 取消指示器
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}

// 创建列表展示
- (void)createListView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (624.0 / 1024) * kScreenWidth * 1.8 - 200) ];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, kScreenWidth * 1.8, (624.0 / 1024) * kScreenWidth * 1.8) ];
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _image_url]]]];
    WKLog(@"heigth = %f",  (624.0 / 1024) * kScreenWidth);
    WKLog(@"%@", _image_url);
    _bgView = bgView;
    [bgView addSubview:imageView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView = bgView;
    // 自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 1000;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKGuideOverviewCell class]) bundle:nil] forCellReuseIdentifier:OverViewCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKGuideImpressionCell class]) bundle:nil] forCellReuseIdentifier:ImpressionCellID];
    [self.tableView registerClass:[WKTableHeaderView class] forHeaderFooterViewReuseIdentifier:tableHeaderID];
    
    [self.view addSubview:self.tableView];
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = self.tableView.contentOffset.y;
//    
//    // 计算tabView滚动的偏移量
//    CGFloat delta = offsetY - self.bgViewOffsetY;
//    
//    CGFloat height = 210 - delta;
//    
//    height = height < 0 ? 0 : height;
//    
////    self.stackTOpConstraint.constant = height;
//    
//    CGFloat alpha = 0;
//    if (height <= 64) {
//        alpha = 0.99;
//        [_bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
//    }else {
//        alpha = 0;
//        [_bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    }
//    
//    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:alpha]];
//    [_bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//
//}

#pragma  mark -----TabvlewView代理
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataArr.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSInteger count = 0;
//    for (NSDictionary *dic in self.dataArr) {
//        count = count + dic.count;
//    }
//    WKLog(@"cellCount = %ld", count);
//    return count;
    return self.dataArr.count;
}


// 使用XIB自适应高度的时候 不能在定义高度

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 250;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKGuideDetailModel *detailModel = self.dataArr1[indexPath.row];
    WKGuideDetailSectionsModel *model = detailModel.sectionsModel;
    WKLog(@"model===%@", model);
    WKLog(@"%@", model.title);
    if ([detailModel.title isEqualToString:@"旅行者印象"]) {
        WKGuideImpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:ImpressionCellID];
        cell.model = model;
        return cell;
    }else if([detailModel.title isEqualToString:@"适宜气候"]){
        WKGuideImpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:ImpressionCellID];
        cell.model = model;
        return cell;
    }else {
        WKGuideOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:OverViewCellID];
        cell.model = model;
        return cell;
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
