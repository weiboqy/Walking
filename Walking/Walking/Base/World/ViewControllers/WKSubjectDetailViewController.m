//
//  WKSubjectDetailViewController.m
//  Walking
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSubjectDetailViewController.h"
#import "WKSubjectModel.h"
#import "WKSubjectDetailModel.h"
#import "WKSubjectDetailSectionsModel.h"
#import "WKSubjectImageTableViewCell.h"
#import "UMSocial.h"

@interface WKSubjectDetailViewController ()<UITableViewDataSource, UITableViewDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) NSMutableArray *headArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *shareArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *customNavigationBar;
@property (nonatomic, strong) UIImageView *navigationBangroundImageView;
@property (nonatomic, strong) UILabel *navigationTitle;
@property (nonatomic, strong) UIButton *infoButton;// 返回按钮
@property (nonatomic, strong) UIImageView *bannerImageView;// 通过这张图片的大小来确定导航栏的透明度

@end

static NSString * const ImageCellID = @"imageCell";

@implementation WKSubjectDetailViewController

- (NSMutableArray *)shareArr {
    if (!_shareArr) {
        _shareArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _shareArr;
}

- (NSMutableArray *)headArray {
    if (!_headArray) {
        self.headArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _headArray;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
//  请求数据
- (void)parseData {
    // 显示指示器
//    [SVProgressHUD show];
    // ID请求参数
    WKLog(@"ID = %@",_ID);
    NSString *url = [NSString stringWithFormat:@"http://chanyouji.com/api/articles/%@.json?page=1",_ID];
    [NetWorkRequestManager requestWithType:GET urlString:url parDic:@{} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        WKSubjectModel *model = [[WKSubjectModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.shareArr addObject:model];
        WKSubjectDetailModel *detailModel = [[WKSubjectDetailModel alloc] init];
        [detailModel setValuesForKeysWithDictionary:dic];
        
        NSArray *array = dic[@"article_sections"];
        for (NSDictionary *detailDic in array) {
            WKSubjectDetailSectionsModel *detailSectionModel = [[WKSubjectDetailSectionsModel alloc] init];
            [detailSectionModel setValuesForKeysWithDictionary:detailDic];
            detailModel.subjectDetailSectionsModel = detailSectionModel;
            [self.dataArray addObject:detailSectionModel];
            WKLog(@"%@",detailSectionModel.image_url);
        }
         
        [self.headArray addObject:detailModel];
//        WKLog(@"headArray is %@", _headArray);
        WKLog(@"dataArray is %@", _dataArray);
//        WKLog(@"%ld",_dataArray.count);
//        WKLog(@"_headArray.count = %ld",_headArray.count);
        // 取消指示器
//        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            //  头视图
            [self createHeadeView];
            //  自定义NagationBar
//            [self addCustomNagationBar];
            
            // 刷新控件
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        // 失败也要取消指示器
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}
// 视图将要出现时,_customNavigationBar的透明度为0,一开始不让它显示
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //  数据请求
    [self parseData];
//    _customNavigationBar.alpha = 0.1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorGlobal;

    // 创建tableView
    [self setupTableView];
    
    [self addCustomNagationBar];
    
    // 创建透明导航栏
//    [self buildNavigationBar];
}

/**
 *  创建tableView
 */
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[WKSubjectImageTableViewCell class]forCellReuseIdentifier:ImageCellID];
}
/**/
- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    bar.backgroundColor = [UIColor clearColor];
    bar.alpha = 0.5;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(18, 10, 70, 30);
    // 设置返回按钮的图片
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    // 自适应尺寸
    [button sizeToFit];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(88, 8, 199, 30);
    [titleBtn setTitle:self.name forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kScreenWidth - 50, 10, 50, 30);
    [shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:shareBtn];
    
    [bar addSubview:titleBtn];

    [bar addSubview:button];
    [self.view addSubview:bar];
}
 
// 透明导航栏
//-(void)buildNavigationBar {
//    _customNavigationBar = [[UIView alloc]init];
//    [self.view addSubview:_customNavigationBar];
//    NSDictionary *views = NSDictionaryOfVariableBindings(_customNavigationBar);
//    NSDictionary *metrics = @{@"HN":@(kNavigationAndStatusBarHeihght)};
//    NSArray *visualFormats = @[@"H:|[_customNavigationBar]|",
//                               @"V:|[_customNavigationBar(==HN)]"
//                               ];
//    [VisualFormatLayout autoLayout:self.view visualFormats:visualFormats metrics:metrics views:views];
//    
//    _navigationBangroundImageView = [[UIImageView alloc]init];
//    _navigationBangroundImageView.contentMode = UIViewContentModeScaleToFill;
//    UIImage *bannerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _image_url]]]];
//    
//    CGSize bannerImageSize = bannerImage.size;
//    CGFloat bannerNavBGImageHeight = bannerImageSize.width / self.view.frame.size.width * kNavigationAndStatusBarHeihght;
//    CGRect navigationBackroundImageRect = CGRectMake(0, 0, bannerImageSize.width, bannerNavBGImageHeight);
//    UIImage *bannerNavBGImage = [bannerImage partImageInRect:navigationBackroundImageRect];
//    _navigationBangroundImageView.image = bannerNavBGImage;
//    [_customNavigationBar addSubview:_navigationBangroundImageView];
//    
//    _navigationTitle = [[UILabel alloc]init];
//    _navigationTitle.text = [NSString stringWithFormat:@"%@",_name];;
//    _navigationTitle.textColor = [UIColor whiteColor];
//    _navigationTitle.textAlignment = NSTextAlignmentCenter;
//    _navigationTitle.font = [UIFont systemFontOfSize:18.0];
//    [_customNavigationBar addSubview:_navigationTitle];
//    
//    
//    _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_infoButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
//    // 自适应尺寸
//    //    [_infoButton sizeToFit];
//    [_infoButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    [_customNavigationBar addSubview:_infoButton];
//    
//    UIButton *share2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [share2 setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
//    [share2 addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
//    [_customNavigationBar addSubview:share2];
//    
//    views = NSDictionaryOfVariableBindings(_navigationBangroundImageView, _navigationTitle, _infoButton, share2);
//    // 使用UIBlurEffect来制作毛玻璃
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
//    effectView.frame = CGRectMake(0, 0, kScreenWidth, 64);
//    [_navigationBangroundImageView addSubview:effectView];
//    _navigationTitle.frame = CGRectMake(kScreenWidth / 2 - 50, 32, 100, 30);
//    
//    _navigationTitle.textAlignment = NSTextAlignmentCenter;
//    metrics = @{@"WB":@(34)};
//    visualFormats =  @[@"H:|[_navigationBangroundImageView]|",
//                       @"H:|-[_infoButton(==WB)]-(-20)-[_navigationTitle]|",
//                       //                       @"H:|-WB-[_navigationTitle]-[share1(==100)]-|",
//                       @"H:|-WB-[_navigationTitle]-[share2(==WB)]-|",
//                       @"H:|[_infoButton(==60)]|",
//                       @"V:|[_navigationBangroundImageView]|",
//                       @"V:|-[_navigationTitle(==50)]|",
//                       @"V:|-[_infoButton(==50)]|",
//                       //                       @"V:|-[share1(==50)]|",
//                       @"V:|-[share2(==50)]|",
//                       ];
//    [VisualFormatLayout autoLayout:_customNavigationBar visualFormats:visualFormats metrics:metrics views:views];
//}
//
//
//
//// 导航条随着滚动而透明度变化
//-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
//    _customNavigationBar.backgroundColor = [UIColor clearColor];
//    CGFloat threholdHeight = _bannerImageView.frame.size.height - kNavigationAndStatusBarHeihght;
//    if(scrollView.contentOffset.y >= 0 &&
//       scrollView.contentOffset.y <= threholdHeight) {
//        _customNavigationBar.alpha = 0.2;
//        CGFloat alpha = scrollView.contentOffset.y / threholdHeight;
//        _customNavigationBar.alpha = alpha + 0.2;
//    }
//    else if(scrollView.contentOffset.y < 0) {
//        _customNavigationBar.alpha = 0.2;
//        scrollView.contentOffset = CGPointMake(0, 0);
//    }
//    else {
//        _customNavigationBar.alpha = 1.0;
//    }
//}
////// 返回按钮
////- (void)backClick {
////    [self.navigationController popViewControllerAnimated:YES];
////}
//- (void)shareClick {
//    WKLog(@"3233");
//    WKLogFun;
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"570bb59a67e58e78b30005a0" shareText:@"shareshare~~~~(输入你想分享的内容)" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,  UMShareToWechatSession, UMShareToQQ, UMShareToQzone,UMShareToEmail, UMShareToSms, UMShareToDouban, UMShareToTencent,   nil] delegate:self];
//}

- (void)backClick{
//    WKLogFun;
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 分享按钮
- (void)shareClick {
    WKSubjectModel *model = self.shareArr[0];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"570bb59a67e58e78b30005a0" shareText:[NSString stringWithFormat:@"我在Walking看到一个有趣的游记哦,这是网址:http://chanyouji.com/articles/%@", model.ID] shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToQQ, UMShareToQzone,UMShareToWechatSession, UMShareToWechatTimeline ,UMShareToEmail, UMShareToSms,  UMShareToTencent,nil] delegate:self];
}
// 创建头视图
- (void)createHeadeView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 自适应文本
    WKSubjectDetailSectionsModel *detailModel = _dataArray[0];
    CGSize maxSize = [detailModel.Description boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil].size;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, (624.0 / 1024) * kScreenWidth * 1.8 - 180 + 10, maxSize.width, maxSize.height)];
    self.label.text = detailModel.Description;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:15.0];
    
    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, (624.0 / 1024) * kScreenWidth * 1.8 - 180 + 30 + maxSize.height)];
    bgView.backgroundColor = [UIColor whiteColor];
    // 请求图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -180, kScreenWidth, (624.0 / 1024) * kScreenWidth * 1.8)];
    WKSubjectDetailModel *model = _headArray[0];
//    WKLog(@"%@",model);
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    [bgView addSubview:imageView];
    
    //通过这张图片的大小来确定导航栏的透明度
    _bannerImageView = imageView;
    
    [bgView addSubview:_label];
    
    // UIView
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (624.0 / 1024) * kScreenWidth * 1.8 - 180 + 20 + maxSize.height, maxSize.width, 2)];
//    [lineView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    lineView.layer.cornerRadius = 2;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:lineView];
    
    self.tableView.tableHeaderView = bgView;
                                                              
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -<UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKSubjectDetailSectionsModel *model = self.dataArray[indexPath.row + 1];
    return model.cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKSubjectImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageCellID];
    cell.model = self.dataArray[indexPath.row + 1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
