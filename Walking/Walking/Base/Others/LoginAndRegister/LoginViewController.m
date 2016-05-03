//
//  LoginViewController.m
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserInfoManager.h"


@interface LoginViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *passworldTF;

@property (strong, nonatomic) IBOutlet UIButton *newuserBtu;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollView];
    
}

- (void)setupScrollView {
    
//    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.newuserBtu.frame) + 10, kScreenWidth, kScreenHeight - CGRectGetMaxY(self.newuserBtu.frame) - 10)];
//    self.imageView.image = [UIImage imageNamed:@"夜空视角.jpg"];
//    self.imageView.backgroundColor = [UIColor redColor];
//    [UIView animateWithDuration:2.0 animations:^{
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDelegate:self];
//        self.imageView.alpha = 0.0;
//        self.imageView.frame = CGRectMake(-60, -85, 440, 635);
//    }];
//    [UIView setAnimationDuration:2.0];
//    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
//    [self.view addSubview:self.imageView];
//    [self.view bringSubviewToFront:self.imageView];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.newuserBtu.frame) + 10, kScreenWidth, kScreenHeight - CGRectGetMaxY(self.newuserBtu.frame) - 10)];
    self.scrollView.contentSize = CGSizeMake(3 * kScreenWidth, 0);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor yellowColor];
    for (int i = 1; i < 4; i ++)  {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * (i - 1), 400, kScreenWidth, 200)];
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        imageView.backgroundColor = [UIColor redColor];
        WKLog(@"%@", NSStringFromCGRect(imageView.frame));
        [self.scrollView addSubview:imageView];
    }
    
//    [self.view addSubview:self.scrollView];
}
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [self.imageView removeFromSuperview];
}

#pragma mark  -----自定义导航条


- (IBAction)registerAction:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self presentViewController:registerVC animated:YES completion:nil];
}


- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)loginAction:(id)sender {
    [SVProgressHUD show];
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    parDic[@"email"] = _emailTF.text;
    parDic[@"passwd"] = _passworldTF.text;
    
    [NetWorkRequestManager requestWithType:POST urlString:@"http://api2.pianke.me/user/login" parDic:parDic finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        WKLog(@"%@", dataDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([dataDic[@"result"] intValue] == 0) {//登陆失败
                NSString *msg = dataDic[@"data"][@"msg"];
                WKLog(@"msg = %@", msg);
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒...." message:[NSString stringWithFormat:@"%@", msg] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            }else { //登陆成功
                //保存用户的auth
                [UserInfoManager conserveUserAuth:dataDic[@"data"][@"auth"]];
                //保持用户的id
                [UserInfoManager conserveUserID:dataDic[@"data"][@"uid"]];
                //保存用户的name
                [UserInfoManager conserveUserName:dataDic[@"data"][@"uname"]];
                //保存用户头像
                [UserInfoManager conserveUsercoverimg:dataDic[@"data"][@"coverimg"]];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"欢迎%@回来", [UserInfoManager getUserName]] message: nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
                
                //                [self dismissViewControllerAnimated:YES completion:nil];
                [SVProgressHUD dismiss];
            }
            
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            //            MenuHeaderView *headerView = [[MenuHeaderView alloc]init];
            //            [headerView.name setTitle:[NSString stringWithFormat:@"%@", dataDic[@"data"][@"uname"]] forState:UIControlStateNormal];
            //            QYLog(@"%@", dataDic[@"data"][@"uname"]);
        });
 
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
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
