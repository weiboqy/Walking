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
#import "UserInfoManager.h"
#import "LoginViewController.h"
@interface WKMeViewController ()<UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *meTableView;
@property (nonatomic, strong) WKMeHeadView *meHeadView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UIView *bgView;//夜间模式视图

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
    
    //用户交互 如果想使用手势 就一定要开启这个 默认是关闭 不然手势不生效
    _meHeadView.headImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.numberOfTapsRequired = 2;
    tap.numberOfTouchesRequired = 1;
    [_meHeadView.headImage addGestureRecognizer:tap];
    
    [_meHeadView.LoginAndRegistButton addTarget:self action:@selector(loginAndRegistButton:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark  ---设置用户头像
- (void)tapClick {
    //创建提醒视图
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒...." message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //判断设备是否存在摄像头，有就调用系统相机，没有，就提醒用户
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //创建相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            //文件由来
            picker.sourceType = UIImagePickerControllerSourceTypeCamera; //指定数据来源来自于相机
            picker.delegate  = self;// 指定代理
            picker.allowsEditing = YES; //允许编辑
            
            //模态弹出
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            //没有摄像头，提醒用户 您的设备没有摄像头
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的设备没有摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [alertController addAction:alertAction1];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    [alertController addAction:alertAction];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
        pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//指定数据来源为相册
        pickerC.delegate = self;  //指定代理
        pickerC.allowsEditing = YES;  // 允许编辑
        [self presentViewController:pickerC animated:YES completion:nil];
    }];
    [alertController addAction:alertAction2];
    UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:alertAction3];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 选取图片之后执行的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _meHeadView.headImage.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark  ----用户登陆、 注册
// 当登陆成功后，将"你还没有登陆哦"换成用户名
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[UserInfoManager getUserAuth] isEqualToString:@" "] ) {
        [_meHeadView.LoginAndRegistButton setTitle:[NSString stringWithFormat:@"%@", [UserInfoManager getUserName]] forState:UIControlStateNormal];
    }else {
        return;
    }
}

//  点击登录注册按钮实现的方法
- (void)loginAndRegistButton:(id)sender {
    //已经登陆 ，取消登陆
    if (![[UserInfoManager getUserAuth] isEqualToString:@" "]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒...." message:@"你已经登陆,是否取消登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UserInfoManager cancelUserAuth];
            [UserInfoManager cancelUserID];
        }];
        [alertController addAction:action];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
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
