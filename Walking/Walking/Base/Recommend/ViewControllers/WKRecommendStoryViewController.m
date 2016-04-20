//
//  WKRecommendStoryViewController.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendStoryViewController.h"
#import "WKStoryListTableViewCell.h"
#import "WKStoryListHeadView.h"

@interface WKRecommendStoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listTableView;



@end

@implementation WKRecommendStoryViewController

- (void)createListTableView{ 
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"WKStoryListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cells"];
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    //指定头视图
    //xib 指定 不行
//    WKStoryListHeadView *headView = [[NSBundle mainBundle] loadNibNamed:@"WKStoryListHeadView" owner:nil options:nil].lastObject;
    WKStoryListHeadView *headView = [[WKStoryListHeadView alloc] initWithFrame:CGRectMake(0, 0, 0, 180)];
//    [headView initializeData];
    headView.imageV.backgroundColor = [UIColor yellowColor];
    
//    headView = [[WKStoryListHeadView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
//    headView.frame = CGRectMake(0, -100, 0, 100);
    headView.backgroundColor = [UIColor grayColor];
    self.listTableView.tableHeaderView = headView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createListTableView];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WKStoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
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
