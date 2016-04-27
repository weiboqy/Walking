//
//  WKSearchDetailViewController.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSearchDetailViewController.h"
#import "WKSearchDetailViewControllerCell.h"
#import "NetWorkRequestManager.h"
#import "WKRecomendSearchDetailModel.h"
#import "WKSearchDetailViewControllerHeadView.h"

@interface WKSearchDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger visited_count;
@property (nonatomic, strong) WKSearchDetailViewControllerHeadView *headView;

@end

@implementation WKSearchDetailViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)requestDataWithStart:(NSInteger)start{
    //    WKLog(@"keyStr:%@", _keyStr);//
//    NSString *startStr = [NSString stringWithFormat:<#(nonnull NSString *), ...#>];
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:RecommendSearchDetailURL, _ID, @(start)] parDic:@{} finish:^(NSData *data) {
        
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        WKLog(@"dataDic:%@", dicData);
        for (NSDictionary *dic in dicData[@"items"]) {
                                
            WKRecomendSearchDetailModel *model = [[WKRecomendSearchDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
//         WKLog(@"dataDic:%@", [self.dataArray[0] cover_s] );
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableView reloadData];
            
            for (WKRecomendSearchDetailModel *model in self.dataArray) {
                _visited_count += [model.visited_count integerValue];
            }
            self.headView.conutLabel.text = [NSString stringWithFormat:@"%ld 去过", _visited_count];
            
//            WKLog(@"%ld", _visited_count);
        });
        
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestDataWithStart:0];
    
    self.listTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.view addSubview:self.listTableView];
    [self.listTableView registerNib:[UINib nibWithNibName:@"WKSearchDetailViewControllerCell" bundle:nil] forCellReuseIdentifier:@"searchDetail"];
    //设置头视图
    self.headView = [[NSBundle mainBundle] loadNibNamed:@"WKSearchDetailViewControllerHeadView" owner:nil options:nil].lastObject;
    self.headView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.2);
    self.headView.backgroundColor  = ColorGlobal;
    self.listTableView.tableHeaderView = self.headView;
    self.headView.titleLabel.text = self.title;
//    self.listTableView.rowHeight = UITableViewAutomaticDimension;
//    self.listTableView.estimatedRowHeight = 300;
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WKSearchDetailViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchDetail" forIndexPath:indexPath];
    WKRecomendSearchDetailModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.name;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:PLACEHOLDER];
    cell.desLabel.text = model.descriptionS;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
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
