//
//  WKCategoryViewController.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKCategoryViewController.h"
#import "WKRouteViewController.h"
#import "WKSubjectViewController.h"
#import "WKGuideViewController.h"

@interface WKCategoryViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation WKCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKLog(@"进来了哦~~");
    
//    [self addCustomNagationBar];
    
    [self bgView];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 背景图 毛玻璃效果
- (void)bgView {
    self.name_zh_cnLabel.text = [NSString stringWithFormat:@"%@", _model.name_zh_cn];
    self.name_enLabel.text = [NSString stringWithFormat:@"%@", _model.name_en];
    self.backgroundImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _model.image_url]]]];
    
    // 使用UIBlurEffect来制作毛玻璃
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = [[UIScreen mainScreen] bounds];
    [self.backgroundImageView addSubview:effectView];
}
//行程
- (IBAction)Route:(id)sender {
    WKRouteViewController *routeVC = [[WKRouteViewController alloc]init];
    routeVC.ID = _ID;
    [self.navigationController pushViewController:routeVC animated:YES];
}

// 游玩指南
- (IBAction)Guide:(id)sender {
    WKGuideViewController *guideVC = [[WKGuideViewController alloc]init];
    guideVC.ID = _ID;
    guideVC.image_url = _model.image_url;
    guideVC.name_zn = _model.name_zh_cn;
    [self.navigationController pushViewController:guideVC animated:YES];
}

// 专题
- (IBAction)Subject:(id)sender {
    WKSubjectViewController *subjectVC = [[WKSubjectViewController alloc]init];
    subjectVC.destination_id = _ID;
    subjectVC.titleName = _model.name_zh_cn;
    [self.navigationController pushViewController:subjectVC animated:YES];
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
