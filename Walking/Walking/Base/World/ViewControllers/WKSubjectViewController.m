//
//  WKSubjectViewController.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSubjectViewController.h"
#import "WKSubjectModel.h"
#import "WKImageSwitchView.h"
#import "WKSubjectDetailViewController.h"

@interface WKSubjectViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WKImageSwitchView *imageSwitchView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation WKSubjectViewController

//  懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

//  请求数据
- (void)parseData {
    // 显示指示器
//    [SVProgressHUD show];
    // ID请求参数
//    WKLog(@"%@",_destination_id);
    NSString *url = [NSString stringWithFormat:@"http://chanyouji.com/api/articles.json?destination_id=%@&page=1", _destination_id];
    [NetWorkRequestManager requestWithType:GET urlString:url parDic:@{} finish:^(NSData *data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dic in array) {
            WKSubjectModel *model = [[WKSubjectModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
//        WKLog(@"%@",self.dataArr);
        // 取消指示器
        [SVProgressHUD dismiss];
        // 刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
//            WKSubjectModel *model = _dataArr[5];
//            self.titleLabel.text = [NSString stringWithFormat:@"- %@ -",model.name];
//            self.detailLabel.text = model.title;
//            [self.Image sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:PLACEHOLDER];
//            [_imageView sd_setImageWithURL:[NSURL URLWithString:_image_url] placeholderImage:PLACEHOLDER];
            
            [self addScrollView];
        });
    } error:^(NSError *error) {
        // 失败也取消指示器
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorGlobal;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.imageSwitchView.imageScrollView.autoresizesSubviews = NO;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
//    _bgView.userInteractionEnabled = YES;
    _bgView.backgroundColor = [UIColor darkGrayColor];
//    _bgView.backgroundColor = ColorGlobal;
    [self.view addSubview:_bgView];
    
    [self addCustomNagationBar];
    [self parseData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    bar.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(18, 10, 70, 30);
    // 设置返回按钮的图片
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    // 自适应尺寸
    [button sizeToFit];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:button];
 
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(kScreenWidth / 2 - 100, 8, 200, 30);
    if ([_titleName isEqualToString:@""]) {
        [titleBtn setTitle:@"专题" forState:UIControlStateNormal];
    }
    [titleBtn setTitle:[NSString stringWithFormat:@"%@专题",_titleName] forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [bar addSubview:titleBtn];
    
    [self.view addSubview:bar];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//  轮播图上将要展示的图片数组
- (NSArray *)imageSwitchViewArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *viewDic in _dataArr) {
        NSInteger index = [_dataArr indexOfObject:viewDic];
        WKSubjectModel *model = [[WKSubjectModel alloc] init];
//        [model setValuesForKeysWithDictionary:viewDic];
        model = _dataArr[index];
        
//        [_bgView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//        effectview.frame = CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height);
//        [_bgView addSubview:effectview];

        // 设置背景框view
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * (295.0 / 375), kScreenWidth * (390.0 / 375))];
        backView.backgroundColor = [UIColor whiteColor];
//        backView.tag = index + 101;
        
//        [_imageSwitchView.imageScrollView addSubview:backView];
        
        // 展示的图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((backView.frame.size.width - kScreenWidth * (285.0 / 375)) / 2, (backView.frame.size.width - kScreenWidth * (285.0 / 375)) / 2, kScreenWidth * (285.0 / 375), kScreenWidth * (285.0 / 375) * (295.0 / 285.0))];
//        WKLog(@"ImageViewCGRect = %@", NSStringFromCGRect(imageView.frame));
        
//        WKLog(@"image_url = %@",model.image_url);
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.image_url]] placeholderImage:PLACEHOLDER];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        imageView.tag = index + 1000;
        [backView addSubview:imageView];
        
        // nameLabel
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((backView.frame.size.width - kScreenWidth * (285.0 / 375)) / 2, (backView.frame.size.width - kScreenWidth * (285.0 / 375)) * 2 + (backView.frame.size.width - kScreenWidth * (285.0 / 375)) / 2 + kScreenWidth * (285.0 / 375) * (295.0 / 285.0), kScreenWidth * (285.0 / 375.0), kScreenHeight * (30.0 / 667))];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = model.name;
        _nameLabel.font = [UIFont boldSystemFontOfSize:23];
        [backView addSubview:_nameLabel];
        
        // titleLabel
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((backView.frame.size.width - kScreenWidth * (285.0 / 375)) / 2, (backView.frame.size.width - kScreenWidth * (285.0 / 375)) * 6 + (backView.frame.size.width - kScreenWidth * (285.0 / 375)) / 2 + kScreenWidth * (285.0 / 375) * (295.0 / 285.0), kScreenWidth * (285.0 / 375.0), kScreenHeight * (20.0 / 667))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = model.title;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [backView addSubview:_titleLabel];
        [array addObject:backView];
    }
    return array;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
    WKSubjectDetailViewController *subjectDetailVC = [[WKSubjectDetailViewController alloc] init];
    UIImageView *image = (UIImageView *)tap.view;
    NSInteger index = image.tag - 1000;
    WKSubjectModel *model = _dataArr[index];
    subjectDetailVC.ID = model.ID;
    subjectDetailVC.image_url = model.image_url;
    subjectDetailVC.name = model.name;
//    [self.navigationController pushViewController:subjectDetailVC animated:YES];
    //模态执行的 方法
    subjectDetailVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:subjectDetailVC animated:YES completion:nil];
}

- (void)addScrollView {
    _imageSwitchView = [[WKImageSwitchView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - kScreenWidth * (390.0 / 375) - 64) / 2, kScreenWidth, kScreenWidth * (390.0 / 375))];
    [_imageSwitchView setImageSwitchViewArray:[self imageSwitchViewArray] delegate:self];
    
//    WKLog(@"cgrect ===== %@", NSStringFromCGRect(_imageSwitchView.frame));
//    WKLog(@"cgrectImageScrollView ===== %@", NSStringFromCGRect(_imageSwitchView.imageScrollView.frame));
//    WKLog(@"cgrectImageView ===== %@", NSStringFromCGRect(_imageView.frame));
    
    [_bgView addSubview:_imageSwitchView];
}

#pragma mark -实现协议方法-
- (void)imageSwitchViewDidScroll:(WKImageSwitchView *)imageSwitchView index:(NSInteger)index {
    _currentIndex = index;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _imageSwitchView = [[WKImageSwitchView alloc] initWithFrame:CGRectMake(_imageSwitchView.frame.origin.x, (kScreenHeight - kScreenWidth * (390.0 / 375) - 64) / 2, _imageSwitchView.frame.size.width, _imageSwitchView.frame.size.height)];
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
