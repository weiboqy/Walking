//
//  WKRecommendStoryViewController.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendStoryViewController.h"
#import "WKStoryListTableViewCell.h"
#import "WKStoryListHeadView.h"
#import "NetWorkRequestManager.h"
#import "WKRecommendStoryDetailModel.h"
#import "WKStoryListTableViewHeadCell.h"

#define kNavigationAndStatusBarHeihght 64

@interface WKRecommendStoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) WKStoryListHeadView *headView;

//显示的 内容
@property (nonatomic, copy) NSString *uName;//作者姓名
@property (nonatomic, copy) NSString *avatar_l;//头像
@property (nonatomic, copy) NSString *name;//trip旅行家
@property (nonatomic, copy) NSString *date_added;//时间
@property (nonatomic, copy) NSString *text;//第一条标题


@property (nonatomic, strong) UIView *customNavigationBar;
@property (nonatomic, strong) UIImageView *navigationBangroundImageView;
@property (nonatomic, strong) UILabel *navigationTitle;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIButton *infoButton;


@end

@implementation WKRecommendStoryViewController


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)requestData{
    
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:RecommendStoryDetailURL, _spot_id] parDic:@{} finish:^(NSData *data) {
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", dicData);
        
        NSDictionary *dicT = dicData[@"data"];
        _text = dicT[@"spot"][@"text"];
        _name = dicT[@"trip"][@"name"];
        _date_added = dicT[@"trip"][@"date_added"];
        _uName = dicT[@"trip"][@"user"][@"name"];
        _avatar_l = dicT[@"trip"][@"user"][@"avatar_l"];
        
        for (NSDictionary *dicN in dicT[@"spot"][@"detail_list"]) {
            WKRecommendStoryDetailModel *detailModel = [[WKRecommendStoryDetailModel alloc] init];
            [detailModel setValuesForKeysWithDictionary:dicN];
            [self.dataArray addObject:detailModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.listTableView reloadData];
            //2016-04-04T13:21:26+08:00
            _headView.timeLabel.text = [NSString stringWithFormat:@"%@", [_date_added substringWithRange:NSMakeRange(0, 10)]];
            _headView.TLabel.text = [NSString stringWithFormat:@"此故事由 %@ 收录于", _uName];
            _headView.titleLabel.text = _name;
            [_headView.icon sd_setImageWithURL:[NSURL URLWithString:_avatar_l]];
        });
        
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
    }];
}

- (void)createListTableView{
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.listTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.listTableView.backgroundColor = [UIColor clearColor];
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    //添加背景图
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = [UIScreen mainScreen].bounds;
        effectview.alpha = 0.5;
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.imageURL]];
    [imageV addSubview:effectview];
    _bannerImageView = imageV;
    [self.view addSubview:imageV];
    [self.view addSubview:self.listTableView];
    
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"WKStoryListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"WKStoryListTableViewHeadCell" bundle:nil] forCellReuseIdentifier:@"listHeadCell"];
    //指定头视图
    //xib 指定 不行
    _headView = [[NSBundle mainBundle] loadNibNamed:@"WKStoryListHeadView" owner:nil options:nil].lastObject;
    _headView.frame = CGRectMake(0, 0, 0, 200);
    [_headView initializeData];
    
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = 1200;

    self.listTableView.tableHeaderView = _headView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self createListTableView];
    
    [self buildNavigationBar];
    
//    self.title = @"精选故事";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self requestData];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void) buildNavigationBar
{
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
    UIImage *bannerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.imageURL]]]];
    
    CGSize bannerImageSize = bannerImage.size;
    CGFloat bannerNavBGImageHeight = bannerImageSize.width / self.view.frame.size.width * kNavigationAndStatusBarHeihght;
    CGRect navigationBackroundImageRect = CGRectMake(0, 0, bannerImageSize.width, bannerNavBGImageHeight);
    UIImage *bannerNavBGImage = [bannerImage partImageInRect:navigationBackroundImageRect];
    _navigationBangroundImageView.image = bannerNavBGImage;
    [_customNavigationBar addSubview:_navigationBangroundImageView];
    
    _navigationTitle = [[UILabel alloc]init];
    _navigationTitle.text = @"精彩故事";
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
    metrics = @{@"WB":@(34)};
    visualFormats =  @[@"H:|[_navigationBangroundImageView]|",
                       @"H:|[_infoButton(==WB)]-[_navigationTitle]-|",
                       @"V:|[_navigationBangroundImageView]|",
                       @"V:|-[_navigationTitle]-|",
                       @"V:|-[_infoButton]-|"
                       ];
    [VisualFormatLayout autoLayout:_customNavigationBar visualFormats:visualFormats metrics:metrics views:views];
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
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    else {
        _customNavigationBar.alpha = 1.0;
    }
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        WKStoryListTableViewHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listHeadCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[WKStoryListTableViewHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listHeadCell"];
        }
        cell.contentLabel.text = _text;
//        cell.textLabel.numberOfLines = 0;
        return cell;
        
    }else{
        WKStoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[WKStoryListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCell"];
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.detailModel = self.dataArray[indexPath.row];
        return cell;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 180;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
