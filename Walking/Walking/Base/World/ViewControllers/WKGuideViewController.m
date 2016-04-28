//
//  WKGuideViewController.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKGuideViewController.h"
#import "WKGuideModel.h"
#import "WKGuideOverviewCell.h"
#import "WKGuideImpressionCell.h"
#import "WKTableHeaderView.h"

#define kNavigationAndStatusBarHeihght 64

@interface WKGuideViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>


/** 数据源 */
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic)NSMutableArray *dataArr1;

/**列表展示*/
@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic)WKNavigtionBar *bar;

/** 记录总偏移量 */
@property (assign, nonatomic)CGFloat bgViewOffsetY;
@property (strong, nonatomic)UIView *bgView;

@property (nonatomic, strong) UIView *customNavigationBar;
@property (nonatomic, strong) UIImageView *navigationBangroundImageView;
@property (nonatomic, strong) UILabel *navigationTitle;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIButton *infoButton;

@end

// TableViewCell标识符
static NSString * const OverViewCellID = @"OverViewCellID";
static NSString * const ImpressionCellID = @"ImpressionCellID";

// TableViewHeader标识符
static NSString * const tableHeaderID = @"tableHeaderID";

@implementation WKGuideViewController

#pragma mark ---- 懒加载
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableArray *)dataArr1 {
    if (_dataArr1 == nil) {
        _dataArr1 = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置全局色背景
    self.view.backgroundColor = ColorGlobal;
    
    // 加载数据
    [self parseData];
    
    [self createListView];
    
    // 自定义导航条
//    [self addCustomNagationBar];
    [self buildNavigationBar];
}


// 加载数据
- (void)parseData {
    // 显示指示器
    [SVProgressHUD showInfoWithStatus:@"正在加载哦~~~"];
//    WKLog(@"ID = %@", _ID);
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://chanyouji.com/api/wiki/destinations/%@.json?page=1", _ID] parDic:@{} finish:^(NSData *data) {
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = dataArr[0];
        NSDictionary *dataDic = dic[@"pages"][0];
        WKGuideModel *model = [[WKGuideModel alloc]init];
        [model setValuesForKeysWithDictionary:dataDic];
        
        for (NSDictionary *detailDic in dataDic[@"children"]) {
            WKGuideDetailModel *detailModel = [[WKGuideDetailModel alloc]init];
            [detailModel setValuesForKeysWithDictionary:detailDic];
            for (NSDictionary *detailDic1 in detailDic[@"sections"]) {
                WKGuideDetailSectionsModel *sectionsModel = [[WKGuideDetailSectionsModel alloc]init];
                [sectionsModel setValuesForKeysWithDictionary:detailDic1];
                
                NSDictionary *userDic = detailDic1[@"user"];
                WKGuideUserModel *userModel = [[WKGuideUserModel alloc]init];
                [userModel setValuesForKeysWithDictionary:userDic];
                sectionsModel.userModel = userModel;
                
                NSArray *arr = detailDic1[@"photos"];
//                WKLog(@"count - %ld", arr.count);
                if (arr.count == 0) {
                    // 空返回
                }
                if (arr.count == 1) {
                    NSDictionary *detailDic2 = detailDic1[@"photos"][0];
                    WKGuideDetailPhotoModel *photoModel = [[WKGuideDetailPhotoModel alloc]init];
                    [photoModel setValuesForKeysWithDictionary:detailDic2];
                    sectionsModel.photoModel = photoModel;
                }
                if (arr.count > 1) {
                    for (NSDictionary *detailDic2 in detailDic1[@"photos"]) {
                        WKGuideDetailPhotoModel *photoModel = [[WKGuideDetailPhotoModel alloc]init];
                        [photoModel setValuesForKeysWithDictionary:detailDic2];
                        sectionsModel.photoModel = photoModel;
                    }
                }
                detailModel.sectionsModel = sectionsModel;
                [self.dataArr addObject:sectionsModel];
                
                [self.dataArr1 addObject:detailModel];
//                WKLog(@"name = %@", model.detailModel.sectionsModel.userModel.name);
                WKLog(@"titleSECTION = %@", model.detailModel.sectionsModel.title);
                
                model.detailModel = detailModel;
                //                [self.dataArr addObject:model];
                //                NSMutableDictionary *dataMutableDic = [[NSMutableDictionary alloc]initWithCapacity:0];
                //                [dataMutableDic setObject:detailModel forKey:detailModel.title];
                //                [self.dataArr addObject:dataMutableDic];
            }
//            WKLog(@"title = %@", model.title);
//            WKLog(@"title1 = %@", model.detailModel.title);
//            WKLog(@"title2 = %@", model.detailModel.sectionsModel.title);
//            WKLog(@"des  = %@", model.detailModel.sectionsModel.descriptioN);
//            WKLog(@"imageUrl = %@", model.detailModel.sectionsModel.photoModel.image_url);
        }
//        WKLog(@"count ARR = %@", self.dataArr);
        // 取消指示器
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        // 取消指示器
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}

// 创建列表展示
- (void)createListView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (624.0 / 1024) * kScreenWidth * 1.8 - 200) ];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 1.8, (624.0 / 1024) * kScreenWidth * 1.8 - 200) ];
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _image_url]]]];
//    WKLog(@"heigth = %f",  (624.0 / 1024) * kScreenWidth);
//    WKLog(@"%@", _image_url);
    _bgView = bgView;
    [_bgView addSubview:imageView];
//    WKLog(@"heigth = %f",  (624.0 / 1024) * kScreenWidth);
//    WKLog(@"%@", _image_url);
    _bannerImageView = imageView;
    [bgView addSubview:imageView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView = bgView;
    // 自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 1000;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKGuideOverviewCell class]) bundle:nil] forCellReuseIdentifier:OverViewCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKGuideImpressionCell class]) bundle:nil] forCellReuseIdentifier:ImpressionCellID];
    [self.tableView registerClass:[WKTableHeaderView class] forHeaderFooterViewReuseIdentifier:tableHeaderID];
    
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
    
    views = NSDictionaryOfVariableBindings(_navigationBangroundImageView, _navigationTitle, _infoButton);
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
                       @"H:|[_infoButton(==60)]|",
                       @"V:|[_navigationBangroundImageView]|",
                       @"V:|-[_navigationTitle(==50)]|",
                       @"V:|-[_infoButton(==50)]|"
                       ];
    [VisualFormatLayout autoLayout:_customNavigationBar visualFormats:visualFormats metrics:metrics views:views];
}

// 视图将要出现时,_customNavigationBar的透明度为0,一开始不让它显示
- (void)viewWillAppear:(BOOL)animated {
    _customNavigationBar.alpha = 0;
}
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat threholdHeight = _bannerImageView.frame.size.height - kNavigationAndStatusBarHeihght;
    if(scrollView.contentOffset.y >= 0 &&
       scrollView.contentOffset.y <= threholdHeight) {
        _customNavigationBar.alpha = 0;
        CGFloat alpha = scrollView.contentOffset.y / threholdHeight;
        _customNavigationBar.alpha = alpha;
    }
    else if(scrollView.contentOffset.y < 0) {
        _customNavigationBar.alpha = 0;
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    else {
        _customNavigationBar.alpha = 1.0;
    }
}
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark -----TabvlewView代理


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}


// 使用XIB自适应高度的时候 不能在定义高度

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 250;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKGuideDetailModel *detailModel = self.dataArr1[indexPath.row];
    WKGuideDetailSectionsModel *model = self.dataArr[indexPath.row];
//    WKLog(@"%@", model.title);
//    WKGuideDetailSectionsModel *model = detailModel.sectionsModel;
//    WKLog(@"model===%@", model);
//    WKLog(@"%@", model.title);
    if ([detailModel.title isEqualToString:@"旅行者印象"]) {
        WKGuideImpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:ImpressionCellID];
        cell.model = model;
        return cell;
    }else if([detailModel.title isEqualToString:@"适宜气候"]){
        WKGuideImpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:ImpressionCellID];
        cell.model = model;
        return cell;
    }else {
        WKGuideOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:OverViewCellID];
        cell.model = model;
        return cell;
    }
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
