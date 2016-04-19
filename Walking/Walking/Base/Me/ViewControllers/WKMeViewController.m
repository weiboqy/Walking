//
//  WKMeViewController.m
//  Walking
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKMeViewController.h"
#import "WKMeHeadView.h"

@interface WKMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *meTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WKMeViewController

//  创建头视图
- (void)creatHeadView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WKMeHeadView" owner:nil options:nil];
    WKMeHeadView *meHeadView = [views lastObject];
    meHeadView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160);
    _meTableView.tableHeaderView = meHeadView;
}

//  分区数组
- (void)creatArray {
    NSMutableArray *oneArray = [[NSMutableArray alloc] initWithObjects:@"我的收藏", nil];
    NSMutableArray *twoArray = [[NSMutableArray alloc] initWithObjects:@"清除缓存", nil];
    NSMutableArray *threeArray = [[NSMutableArray alloc] initWithObjects:@"夜间模式", nil];
    NSMutableArray *fourArray = [[NSMutableArray alloc] initWithObjects:@"关于我们", nil];
    _dataArray = [[NSMutableArray alloc] initWithObjects:oneArray,twoArray,threeArray,fourArray, nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
////    static NSString *resu
////    UITableViewCell *cell = [tableView dequ]
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
