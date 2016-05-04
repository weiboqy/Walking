//
//  WKRouteDetailViewController.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRouteDetailViewController.h"
#import "WKRouteModel.h"
#import "WKRouteDetailCell.h"
#import "UMSocial.h"




@interface WKRouteDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate>

// 数据源
@property (strong, nonatomic)NSMutableArray *dataArr;
// 头视图数据源
@property (nonatomic, strong)NSMutableArray *headerDataArr;

@property (copy, nonatomic)NSString *name;

// 列表
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) UIView *customNavigationBar;
@property (nonatomic, strong) UIImageView *navigationBangroundImageView;
@property (nonatomic, strong) UILabel *navigationTitle;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIButton *infoButton1;

@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, copy)NSString *urlStr;



@end

static NSString * const TableViewCellID = @"TableViewCellID";

@implementation WKRouteDetailViewController

#pragma mark  ----懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableArray *)headerDataArr {
    if (!_headerDataArr) {
        _headerDataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _headerDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色
    self.view.backgroundColor = ColorGlobal;
    
    // 创建TableView
    [self setupSubViews];
    
    // 加载数据
    [self loadData];
    
    // 自定义透明导航条
    [self buildNavigationBar];
}


// 自定义导航条


// 加载数据
- (void)loadData {
    // 显示指示器
    [SVProgressHUD showInfoWithStatus:@"正在加载哦~~~"];
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://chanyouji.com/api/plans/%@.json?page=1", _ID] parDic:@{} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        WKLog(@"%@", dataDic);
        WKRouteModel *model = [[WKRouteModel alloc]init];
        [model setValuesForKeysWithDictionary:dataDic];
        [self.headerDataArr addObject:model];
        for (NSDictionary *planDic in dataDic[@"plan_days"]) {
            for (NSDictionary *dic in planDic[@"plan_nodes"]) {
                NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithCapacity:0];
                WKRoutePlanModel *planModel = [[WKRoutePlanModel alloc]init];
                [planModel setValuesForKeysWithDictionary:dic];
                NSDictionary *nameDic = dic[@"destination"];
                NSString *name = nameDic[@"name_zh_cn"];
                _name = name;
                [mDic setValue:planModel forKey:name];
                [self.dataArr addObject:planModel];
            }
        }
//        WKLog(@"count = %ld", self.dataArr.count);
//        for (NSDictionary *dic in self.dataArr) {
//            WKLog(@"%@ ",dic);
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        // 取消指示器
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败哦~~"];
    }];
}

// 创建TableView
- (void)setupSubViews {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180) ];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _image_url]]]];
//    WKLog(@"heigth = %f",  (624.0 / 1024) * kScreenWidth);
//    WKLog(@"%@", _image_url);
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 300, 25)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = [NSString stringWithFormat:@"%@", _name_zn];
    nameLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:nameLabel];
//    WKLog(@"name = %@", _plan_nodes_counts);
    UILabel *daysLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, 40, 20)];
    daysLabel.text = [NSString stringWithFormat:@"%@天/", _days];
    daysLabel.font = [UIFont systemFontOfSize:12];
    daysLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:daysLabel];
    
    UILabel *countsLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 130, 100, 20)];
    countsLabel.font = [UIFont systemFontOfSize:12];
    countsLabel.text = [NSString stringWithFormat:@"7个旅行地"];
    countsLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:countsLabel];
    _bannerImageView = imageView;
    [bgView addSubview:imageView];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = bgView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKRouteDetailCell class]) bundle:nil] forCellReuseIdentifier:TableViewCellID];
    [self.view addSubview:self.tableView];
}

// 透明导航栏
-(void)buildNavigationBar {
    _customNavigationBar = [[UIView alloc]init];
    [self.view addSubview:_customNavigationBar];
    NSDictionary *views = NSDictionaryOfVariableBindings(_customNavigationBar);
    NSDictionary *metrics = @{@"HN":@(kNavigationAndStatusBarHeihght)};
    NSArray *visualFormats = @[@"H:|[_customNavigationBar]|",
                               @"V:|[_customNavigationBar(==HN)]"
                               ];
    [VisualFormatLayout autoLayout:self.view visualFormats:visualFormats metrics:metrics views:views];
    
    _navigationBangroundImageView = [[UIImageView alloc]init];
    _navigationBangroundImageView.contentMode = UIViewContentModeScaleToFill;
    UIImage *bannerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _image_url]]]];
    
    CGSize bannerImageSize = bannerImage.size;
    CGFloat bannerNavBGImageHeight = bannerImageSize.width / self.view.frame.size.width * kNavigationAndStatusBarHeihght;
    CGRect navigationBackroundImageRect = CGRectMake(0, 0, bannerImageSize.width, bannerNavBGImageHeight);
    UIImage *bannerNavBGImage = [bannerImage partImageInRect:navigationBackroundImageRect];
    _navigationBangroundImageView.image = bannerNavBGImage;
    [_customNavigationBar addSubview:_navigationBangroundImageView];
    
    _navigationTitle = [[UILabel alloc]init];
    _navigationTitle.text = [NSString stringWithFormat:@"%@游玩指南", _name_zn];;
    _navigationTitle.textColor = [UIColor whiteColor];
    _navigationTitle.textAlignment = NSTextAlignmentCenter;
    _navigationTitle.font = [UIFont systemFontOfSize:18.0];
    [_customNavigationBar addSubview:_navigationTitle];
    
    
    _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_infoButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    // 自适应尺寸
    //    [_infoButton sizeToFit];
    [_infoButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_customNavigationBar addSubview:_infoButton];
   
    UIButton *share2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [share2 setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [share2 addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [_customNavigationBar addSubview:share2];
    
    views = NSDictionaryOfVariableBindings(_navigationBangroundImageView, _navigationTitle, _infoButton, share2);
    // 使用UIBlurEffect来制作毛玻璃
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0, 0, kScreenWidth, 64);
    [_navigationBangroundImageView addSubview:effectView];
    _navigationTitle.frame = CGRectMake(kScreenWidth / 2 - 50, 32, 100, 30);
    
    _navigationTitle.textAlignment = NSTextAlignmentCenter;
    metrics = @{@"WB":@(34)};
    visualFormats =  @[@"H:|[_navigationBangroundImageView]|",
                       @"H:|-[_infoButton(==WB)]-(-20)-[_navigationTitle]|",
                       //                       @"H:|-WB-[_navigationTitle]-[share1(==100)]-|",
                       @"H:|-WB-[_navigationTitle]-[share2(==WB)]-|",
                       @"H:|[_infoButton(==60)]|",
                       @"V:|[_navigationBangroundImageView]|",
                       @"V:|-[_navigationTitle(==50)]|",
                       @"V:|-[_infoButton(==50)]|",
                       //                       @"V:|-[share1(==50)]|",
                       @"V:|-[share2(==50)]|",
                       ];
    [VisualFormatLayout autoLayout:_customNavigationBar visualFormats:visualFormats metrics:metrics views:views];
}


// 视图将要出现时,_customNavigationBar的透明度为0,一开始不让它显示
- (void)viewWillAppear:(BOOL)animated {
    _customNavigationBar.alpha = 0.1;
}

// 导航条随着滚动而透明度变化
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat threholdHeight = _bannerImageView.frame.size.height - kNavigationAndStatusBarHeihght;
    if(scrollView.contentOffset.y >= 0 &&
       scrollView.contentOffset.y <= threholdHeight) {
        _customNavigationBar.alpha = 0.1;
        CGFloat alpha = scrollView.contentOffset.y / threholdHeight;
        _customNavigationBar.alpha = alpha;
    }
    else if(scrollView.contentOffset.y < 0) {
        _customNavigationBar.alpha = 0.1;
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    else {
        _customNavigationBar.alpha = 1.0;
    }
}
// 返回按钮
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)shareClick {
    WKRouteModel *routeModel = self.headerDataArr[0];
   
    // dibu展示
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"570bb59a67e58e78b30005a0" shareText:[NSString stringWithFormat:@"我在Walking看到一个有趣的游记哦,这是网址:http://chanyouji.com/plans/%@", routeModel.ID] shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,  UMShareToWechatSession, UMShareToQQ, UMShareToQzone,UMShareToEmail, UMShareToSms, UMShareToDouban, UMShareToTencent,   nil] delegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.dataArr.count == 0) {
//        return 0;
//    }else {
//        
//        NSDictionary *dic = self.dataArr[section];
//        WKLog(@"=====%ld", [dic allKeys].count);
//        return [dic allKeys].count;
//    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKRouteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellID forIndexPath:indexPath];
    WKRoutePlanModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    _urlStr = model.image_url;
    cell.image_urlImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [cell.image_urlImageView addGestureRecognizer:tap];
    return cell;
}

// 图片点击手势
- (void)tapClick {
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    imageView.bounds = CGRectMake(0, 0, 0, 0);
    dispatch_async(dispatch_get_main_queue(), ^{
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _urlStr]] placeholderImage:PLACEHOLDER];
    });
    
    UIPinchGestureRecognizer  *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchClick:)];
    [imageView addGestureRecognizer:pinch];
    imageView.userInteractionEnabled = YES;
    UIView *bgView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [bgView addGestureRecognizer:tap];
    [UIView animateWithDuration:.25 animations:^{
        imageView.bounds = CGRectMake(0, 0, kScreenWidth, 400);
    }];
    [bgView addSubview:imageView];
    _bgView = bgView;
    _imageView = imageView;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
}
- (void)pinchClick:(UIPinchGestureRecognizer *)pinch {
    //获取要进行缩放的视图
    _imageView = (UIImageView *)pinch.view;
    _imageView.transform = CGAffineTransformScale(_imageView.transform, pinch.scale, pinch.scale);  //以imageV.transform为基础
    pinch.scale = 1;
}

- (void)tapAction {
    [_bgView removeFromSuperview];
}

@end
