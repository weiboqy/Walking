//
//  RegisterViewController.m
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserInfoManager.h"

@interface RegisterViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *EmilTF;
@property (strong, nonatomic) IBOutlet UITextField *passworldTF;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerAction:(id)sender {
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    parDic[@"email"] = _EmilTF.text;
    parDic[@"passwd"] = _passworldTF.text;
    parDic[@"uname"] = _nameLabel.text;
    [NetWorkRequestManager requestWithType:POST urlString:@"http://api2.pianke.me/user/reg" parDic:parDic finish:^(NSData *data) {
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
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        });
    } error:^(NSError *error) {
        
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
