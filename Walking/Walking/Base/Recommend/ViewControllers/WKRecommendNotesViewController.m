//
//  WKRecommendNotesViewController.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendNotesViewController.h"
#import "WKNotesListTableViewCell.h"
#import "WKNotesListHeadView.h"
#import "NetWorkRequestManager.h"
#import "WKRecommendNotesDetailModel.h"

@interface WKRecommendNotesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *listTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) WKNotesListHeadView *headView;


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mileage;
@property (nonatomic, strong) NSString *day_count;
@property (nonatomic, strong) NSString *recommendations;
@property (nonatomic, strong) NSString *imageT;
@property (nonatomic, strong) NSString *uName;
@property (nonatomic, strong) NSString *avatar_m;

@end

@implementation WKRecommendNotesViewController


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)requestData{
    
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:RecommendTableViewDetailURL, _ID] parDic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        WKLog(@"%@", dic);
        //获取头视图的 数据
        _name = dic[@"name"];
        _mileage = dic[@"mileage"];
        _day_count = dic[@"day_count"];
        _recommendations = dic[@"recommendations"];
        _imageT = dic[@"trackpoints_thumbnail_image"];
        _avatar_m = dic[@"user"][@"avatar_m"];
        _uName = dic[@"user"][@"name"];
        //cell中模型赋值
        for (NSDictionary *dicT in dic[@"days"]) {
            for (NSDictionary *dicc in dicT[@"waypoints"]) {
                WKRecommendNotesDetailModel *model = [[WKRecommendNotesDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:dicT];
                [model setValuesForKeysWithDictionary:dicc];
                [self.dataArray addObject:model];
            }
        }
//        WKLog(@" %@, %@",  _recommendations, [self.dataArray[0] photo]);
        dispatch_async(dispatch_get_main_queue(), ^{
            //头视图 的空间 赋值
            [self.listTableView reloadData];
            self.headView.titleLabel.text = _name;
            [self.headView.imageV sd_setImageWithURL:[NSURL URLWithString:_imageT] placeholderImage:PLACEHOLDER];
            [self.headView.icon sd_setImageWithURL:[NSURL URLWithString:_avatar_m] placeholderImage:PLACEHOLDER];
//            WKLog(@"%@", _uName);
            self.headView.nameLabel.text = _uName;
            NSArray *strArray = [(NSString *)[NSString stringWithFormat:@"%@", _mileage] componentsSeparatedByString:@"."];
            self.headView.motersLabel.text = strArray[0];
            self.headView.daysLabel.text = [NSString stringWithFormat:@"%@", _day_count];
            self.headView.lovesLabel.text = [NSString stringWithFormat:@"%@",  _recommendations];
        });
        
    } error:^(NSError *error) {
        WKLog(@"error:%@", error);
    }];
}

- (void)createListTableView{
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"WKNotesListTableViewCell" bundle:nil] forCellReuseIdentifier:@"notesReuse"];
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"WKNotesListHeadView" owner:nil options:nil] lastObject];
    _headView.backgroundColor = ColorGlobal;
    _headView.frame = CGRectMake(0, 0, kScreenWidth, 300);
    [_headView handleImage];//处理图片
    self.listTableView.tableHeaderView = _headView;
    
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = 50;
    
    [self.view addSubview:self.listTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.view.backgroundColor = ColorGlobal;
    self.title = @"精彩游记";
    [self createListTableView];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WKNotesListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notesReuse" forIndexPath:indexPath];
    cell.detailModel = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = ColorGlobal;
    return  cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 320;
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
