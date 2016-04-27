//
//  WKTravelNoteViewController.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKTravelNoteViewController.h"
#import "WKTravelNoteModel.h"
#import "WKTravelNoteTableViewCell.h"
#import "WKTravelNoteDetailViewController.h"

@interface WKTravelNoteViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)NSMutableArray *dataArr;

@property (strong, nonatomic)UITableView *tableView;

@end

static NSString * const TableViewCellID = @"TableViewCellID";

@implementation WKTravelNoteViewController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorGlobal;
    
    [self createListView];
    
    [self parseData];
    
    [self addCustomNagationBar];
    // Do any additional setup after loading the view from its nib.
}

- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenHeight, 44)];
    bar.titleLabel.text = _name_zn;
    bar.titleLabel.center = CGPointMake(kScreenWidth / 2, 44);
    bar.titleLabel.bounds = CGRectMake(0, 0, 40, 30);
    bar.titleLabel.textAlignment = 2;
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

- (void)parseData {
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://chanyouji.com/api/destinations/trips/%@.json?month=0&page=1", _ID] parDic:@{} finish:^(NSData *data) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        WKLog(@"%@", arr);
        for (NSDictionary *dic in arr) {
            WKTravelNoteModel *travelNoteModel = [[WKTravelNoteModel alloc]init];
            [travelNoteModel setValuesForKeysWithDictionary:dic];
            NSDictionary *userDic = dic[@"user"];
            WKTravelNoteUserModel *userModel = [[WKTravelNoteUserModel alloc]init];
            [userModel setValuesForKeysWithDictionary:userDic];
            travelNoteModel.userModel = userModel;
            [self.dataArr addObject:travelNoteModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } error:^(NSError *error) {
        
    }];
}


- (void)createListView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight -  44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKTravelNoteTableViewCell class]) bundle:nil] forCellReuseIdentifier:TableViewCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKTravelNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellID];
    WKTravelNoteModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    WKTravelNoteDetailViewController *detailVC = [[WKTravelNoteDetailViewController alloc]init];
//    WKTravelNoteModel *model = self.dataArr[indexPath.row];
//    detailVC.ID = model.ID;
//    [self.navigationController pushViewController:detailVC animated:YES];
//}


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
