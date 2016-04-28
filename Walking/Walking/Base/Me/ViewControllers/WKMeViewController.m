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
#import "WKAboutUsViewController.h"
#import "WKTabBarViewController.h"
@interface WKMeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *meTableView;
@property (nonatomic, strong) WKMeHeadView *meHeadView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UIView *bgView;//夜间模式视图
/** 沙盒中缓存文件的大小 */
@property (assign, nonatomic) unsigned long long size;

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
    NSMutableArray *twoArray = [[NSMutableArray alloc] initWithObjects:@"清理缓存", nil];
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

- (void)viewWillAppear:(BOOL)animated {
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _size = [self folderSizeAtPath:cachPath];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    UITableViewCell *cell = [self.meTableView cellForRowAtIndexPath:indexPath];
    NSString *dataText = _dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%lluM)",dataText,_size];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController setNavigationBarHidden:YES];
    // 显示头logo
    [self setTitleImage];

    _meTableView.backgroundColor = ColorGlobal;
    // 创建头视图
    [self creatHeadView];
    // 分区数组
    [self creatArray];
    // 登录注册的按钮
    [self loginAndRegistButton];
    
    // 夜间模式
//    [self setupBgView];
    
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
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"收藏"];
    }
    
    // 清除缓存
    if (indexPath.section == 1) {
        NSString *dataText = _dataArray[indexPath.section][indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%lluM)",dataText,_size];
        cell.imageView.image = [UIImage imageNamed:@"清洁"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // 夜间模式
    if (indexPath.section == 2) {
        cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"夜间模式"];
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(10, 300, 50, 20)];
        [switchView addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    
    // 关于我们
    if (indexPath.section == 3) {
        cell.imageView.image = [UIImage imageNamed:@"关于我们"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
}
/**  夜间模式*/
- (void)updateSwitchAtIndexPath:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    if ([switchView isOn]) {
//        self.bgView.hidden = NO;
        [[WKDarkLightMode defaultManager] darkmode];
        [WKDarkLightMode defaultManager].type = WKDarkLightModeTypeDark;
        NSLog(@"开");
    } else {
//        self.bgView.hidden = YES;
        [[WKDarkLightMode defaultManager] lightmode];
        [WKDarkLightMode defaultManager].type = WKDarkLightModeTypeLight;
        NSLog(@"关");
    }
}

- (void)setupBgView {
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3;
    bgView.userInteractionEnabled = NO;
    self.bgView = bgView;
    WKTabBarViewController *tab = (WKTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tab.view insertSubview:bgView atIndex:[UIApplication sharedApplication].windows.count ];
//    [self.view bringSubviewToFront:vc.view];
//    bgView.hidden = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 不加此句时，在二级栏目点击返回时，此行会由选中状态慢慢变成非选中状态。加上此句，返回时直接就是非选中状态。
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            // 进入我的收藏界面
            WKMyCollectionViewController *myCollectionVC = [[WKMyCollectionViewController alloc] init];
            [self.navigationController pushViewController:myCollectionVC animated:YES];
            break;
        }
        case 1:{
            // 清理缓存
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否清理缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 2001;
            [alertView show];
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

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor redColor];
    CGRect rect = view.frame;
    rect.size.height = 2;
    view.frame = rect;
    NSLog(@"Header%@",NSStringFromCGRect(view.frame));
    return view;
}
 */
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

#pragma mark -UIAlertViewDelegate-

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView.tag == 2001) {
        [self clearCache];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        UITableViewCell *cell = [self.meTableView cellForRowAtIndexPath:indexPath];
        NSString *dataText = _dataArray[indexPath.section][indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@(0M)",dataText];
    }
}

/** 清理缓存 */
- (void)clearCache {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        WKLog(@"cachPath is %@", cachPath);
        // 查找给定路径下的所有子路径，返回一个数组
        NSArray *filesArray = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *fileName in filesArray) {
            NSError *error;
            // 拼接子文件路径
            NSString *childPath = [cachPath stringByAppendingPathComponent:fileName];
            // 判断文件或目录是否存在
            if ([[NSFileManager defaultManager] fileExistsAtPath:childPath]) {
                
                [[NSFileManager defaultManager] removeItemAtPath:childPath error:&error];
            }
        }
       // 会创建一个新的线程实行clearCacheSuccess函数，并且会等待函数退出后再继续执行。
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
    });
}
/** 计算缓存目录大小 */
- (float)folderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    unsigned long long size = 0;
    
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if (!([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size += fileAttributeDic.fileSize;
        }
        else
        {
            [self folderSizeAtPath:fullPath];
        }
    }
    _size += size;
    return _size / (1024.0 * 1024.0);
}

/** 清理缓存成功 */
- (void)clearCacheSuccess {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"缓存清理成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
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
