//
//  WKMeViewController.m
//  Walking
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKMeViewController.h"
#import "WKMeHeadView.h"
#import "WKMyCollectionViewController.h"
#import "WKAboutUsViewController.h"
#import "WKLoginAndRegistViewController.h"

@interface WKMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *meTableView;
@property (nonatomic, strong) WKMeHeadView *meHeadView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WKMeViewController

//  创建头视图
- (void)creatHeadView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WKMeHeadView" owner:nil options:nil];
    _meHeadView = [views lastObject];
    _meHeadView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
//    meHeadView.headImage.layer.masksToBounds = YES;
//    meHeadView.headImage.layer.cornerRadius = 35;
    _meTableView.tableHeaderView = _meHeadView;
}

//  分区数组
- (void)creatArray {
    NSMutableArray *oneArray = [[NSMutableArray alloc] initWithObjects:@"我的收藏", nil];
    NSMutableArray *twoArray = [[NSMutableArray alloc] initWithObjects:@"清除缓存", nil];
    NSMutableArray *threeArray = [[NSMutableArray alloc] initWithObjects:@"夜间模式", nil];
    NSMutableArray *fourArray = [[NSMutableArray alloc] initWithObjects:@"关于我们", nil];
    _dataArray = [[NSMutableArray alloc] initWithObjects:oneArray,twoArray,threeArray,fourArray, nil];
}

//  头logo
- (void)setTitleImage {
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 93, 30)];
    titleImage.image = [UIImage imageNamed:@"Walking细"];
    self.navigationItem.titleView = titleImage;
}

//  登录注册的按钮
- (void)loginAndRegistButton {
    [_meHeadView.LoginAndRegistButton addTarget:self action:@selector(loginAndRegistButton:) forControlEvents:UIControlEventTouchUpInside];
}

//  点击登录注册按钮实现的方法
- (void)loginAndRegistButton:(id)sender {
    WKLoginAndRegistViewController *LoginAndRegistVC = [[WKLoginAndRegistViewController alloc] init];
    [self.navigationController pushViewController:LoginAndRegistVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController setNavigationBarHidden:YES];
    [self setTitleImage];

    self.view.backgroundColor = ColorGlobal;
    
//    UIImageView *titleImage = [UIImageView alloc]initWithFrame:<#(CGRect)#>
    _meTableView.backgroundColor = ColorGlobal;
    
    [self creatHeadView];
    [self creatArray];
    [self loginAndRegistButton];
    
    // Do any additional setup after loading the view from its nib.
}
//  分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
//  每个分区行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}
//  cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentitfier = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentitfier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentitfier];
    }
    _meTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 2) {
        cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(10, 300, 50, 20)];
        [switchView addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    return cell;
}
/**  夜间模式*/
- (void)updateSwitchAtIndexPath:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    if ([switchView isOn]) {
//        [switchView setOn:NO animated:YES];
        NSLog(@"开");
    } else {
        NSLog(@"关");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            // 进入我的收藏界面
            WKMyCollectionViewController *myCollectionVC = [[WKMyCollectionViewController alloc] init];
            [self.navigationController pushViewController:myCollectionVC animated:YES];
            break;
        }
        case 1:{
            // 清除缓存
            
            break;
        }
        case 2:{
            // 夜间模式
            break;
        }
        case 3:{
            // 进入关于我们界面
            WKAboutUsViewController *aboutUsVC = [[WKAboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
            break;
        }
        default:
            break;
    }
}



//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor redColor];
//    CGRect rect = view.frame;
//    rect.size.height = 2;
//    view.frame = rect;
//    NSLog(@"Header%@",NSStringFromCGRect(view.frame));
//    return view;
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
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
