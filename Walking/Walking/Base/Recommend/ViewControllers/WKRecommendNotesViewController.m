//
//  WKRecommendNotesViewController.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendNotesViewController.h"
#import "WKNotesListTableViewCell.h"
#import "WKNotesListHeadView.h"
#import "NetWorkRequestManager.h"
#import "WKRecommendNotesDetailModel.h"

#define kNavigationAndStatusBarHeihght 64

@interface WKRecommendNotesViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *listTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) WKNotesListHeadView *headView;
@property (nonatomic, strong) UIView *imView;
@property (nonatomic, strong) UIView *scroView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mileage;
@property (nonatomic, strong) NSString *day_count;
@property (nonatomic, strong) NSString *recommendations;
@property (nonatomic, strong) NSString *imageT;
@property (nonatomic, strong) NSString *uName;
@property (nonatomic, strong) NSString *avatar_m;

@property (nonatomic, strong) UIView *customNavigationBar;
@property (nonatomic, strong) UIImageView *navigationBangroundImageView;
@property (nonatomic, strong) UILabel *navigationTitle;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIButton *infoButton;

@end

@implementation WKRecommendNotesViewController


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)requestData{
    
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:RecommendTableViewDetailURL, _ID] parDic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        WKLog(@"%@", dic);
        //获取头视图的 数据
        _name = dic[@"name"];
        _mileage = dic[@"mileage"];
        _day_count = dic[@"day_count"];
        _recommendations = dic[@"recommendations"];
        _imageT = dic[@"trackpoints_thumbnail_image"];
        _avatar_m = dic[@"user"][@"avatar_m"];
        _uName = dic[@"user"][@"name"];
        //cell中模型赋值
        for (NSDictionary *dicT in dic[@"days"]) {
            for (NSDictionary *dicc in dicT[@"waypoints"]) {
                WKRecommendNotesDetailModel *model = [[WKRecommendNotesDetailModel alloc] init];
                WKRecommendNotesDetailPhotoModel *photoModel = [[WKRecommendNotesDetailPhotoModel alloc] init];
                [photoModel setValuesForKeysWithDictionary:dicc[@"photo_info"]];
                [model setValuesForKeysWithDictionary:dicT];
                [model setValuesForKeysWithDictionary:dicc];
                model.photoModel = photoModel;
                [self.dataArray addObject:model];
            }
        }
//        WKLog(@" %@, %@",  _recommendations, [self.dataArray[0] photo]);
        dispatch_async(dispatch_get_main_queue(), ^{
            //头视图 的空间 赋值
            [self.listTableView reloadData];
            self.headView.titleLabel.text = _name;
            [self.headView.imageV sd_setImageWithURL:[NSURL URLWithString:_imageT] placeholderImage:PLACEHOLDER];
            [self.headView.icon sd_setImageWithURL:[NSURL URLWithString:_avatar_m] placeholderImage:PLACEHOLDER];
//            WKLog(@"%@", _uName);
            self.headView.nameLabel.text = [NSString stringWithFormat:@"By:%@", _uName];
            NSArray *strArray = [(NSString *)[NSString stringWithFormat:@"%@", _mileage] componentsSeparatedByString:@"."];
            self.headView.motersLabel.text = strArray[0];
            self.headView.daysLabel.text = [NSString stringWithFormat:@"%@", _day_count];
            self.headView.lovesLabel.text = [NSString stringWithFormat:@"%@",  _recommendations];
        });
        
    } error:^(NSError *error) {
        WKLog(@"error:%@", error);
    }];
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
    UIImage *bannerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _imageT]]]];
    
    CGSize bannerImageSize = bannerImage.size;
    CGFloat bannerNavBGImageHeight = bannerImageSize.width / self.view.frame.size.width * kNavigationAndStatusBarHeihght;
    CGRect navigationBackroundImageRect = CGRectMake(0, 0, bannerImageSize.width, bannerNavBGImageHeight);
    UIImage *bannerNavBGImage = [bannerImage partImageInRect:navigationBackroundImageRect];
    _navigationBangroundImageView.image = bannerNavBGImage;
    [_customNavigationBar addSubview:_navigationBangroundImageView];
    
    _navigationTitle = [[UILabel alloc]init];
    _navigationTitle.text = @"精彩游记";
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
    //    _navigationTitle.center = CGPointMake(kScreenWidth / 2, 22);
    //    _navigationTitle.bounds = CGRectMake(0, 0, 100, 30);
    _navigationTitle.frame = CGRectMake(kScreenWidth / 2 - 50, 32, 100, 30);
    
    _navigationTitle.textAlignment = NSTextAlignmentCenter;
    metrics = @{@"WB":@(34)};
    visualFormats =  @[@"H:|[_navigationBangroundImageView]|",
                       @"H:|-[_infoButton(==WB)]-(-20)-[_navigationTitle]|",
                       @"H:|[_infoButton(==60)]|",
                       //                       @"H:|[_navigationTitle(==390)]|",
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
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createListTableView{
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44)];
    
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"WKNotesListTableViewCell" bundle:nil] forCellReuseIdentifier:@"notesReuse"];
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"WKNotesListHeadView" owner:nil options:nil] lastObject];
    _headView.backgroundColor = ColorGlobal;
    _headView.frame = CGRectMake(0, 0, kScreenWidth, (340/667.0) * kScreenHeight);
    [_headView handleImage];//处理图片
    self.listTableView.tableHeaderView = _headView;
    
//#warning mark --- cellHeight-----
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = 20;
    
    [self.view addSubview:self.listTableView];
}

// 自定义导航条
- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenHeight, 44)];
    bar.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(18, 10, 70, 30);
    // 设置返回按钮的图片
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    // 自适应尺寸
    [button sizeToFit];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:button];
    [self.view addSubview:bar];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = NO;
//    self.tabBarController.tabBar.translucent = NO;
    self.view.backgroundColor = ColorGlobal;
//    self.title = @"精彩游记";
    [self createListTableView];
    [self requestData];
    
//    [self addCustomNagationBar];
    [self buildNavigationBar];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WKNotesListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notesReuse" forIndexPath:indexPath];
    cell.detailModel = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = ColorGlobal;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WKLog(@"%ld", indexPath.row);
    
//    self.navigationController.navigationBarHidden = YES;
    _imView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _imView.backgroundColor = [UIColor blackColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    scrollView.alwaysBounceHorizontal = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * self.dataArray.count, 0);
    _scrollView.pagingEnabled = YES;
     _scrollView.bounces = NO;
    //设置偏移量
    _scrollView.contentOffset = CGPointMake(kScreenWidth * indexPath.row, 0);
//    scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;

    CGFloat flo =  (kScreenWidth - 20) / self.dataArray.count;
    
    int i = 0;
    for (WKRecommendNotesDetailModel *model in self.dataArray) {
        i ++;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1), 0, [UIScreen mainScreen].bounds.size.width, (300 / 667.0) * kScreenHeight)];
//        imageV.frame.size.height = model    //可以设置图片的高度 
        imageV.contentMode =  UIViewContentModeScaleToFill;
        imageV.clipsToBounds = YES;
        imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //设置 中心位置
        CGPoint imageVp = imageV.center;
        CGFloat p = _scrollView.center.y;
        imageVp.y = p;
        imageV.center = imageVp;
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kScreenWidth * (i - 1), (500/ 667.0) * kScreenHeight, kScreenWidth, (110/667.0) * kScreenHeight)];
        textView.backgroundColor = [UIColor blackColor];
        textView.showsVerticalScrollIndicator = NO;
        textView.font = [UIFont systemFontOfSize:14.0];
        textView.text = model.text;
        textView.textColor = [UIColor whiteColor];
        textView.editable = NO;
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:PLACEHOLDER];
        imageV.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
        [imageV addGestureRecognizer:longTap];
        [imageV addGestureRecognizer:tap];
        [_scrollView addSubview:textView];
//        [scrollView addSubview:view];
//        [scrollView addSubview:_scroView];
        [_scrollView addSubview:imageV];
    }
    //添加下边的滑动条
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((10/375.0) * kScreenWidth, (620/667.0) * kScreenHeight, kScreenWidth - 20, (3/667.0) * kScreenHeight)];//(620/667.0) * kScreenHeight
    view.backgroundColor = [UIColor grayColor];
    self.scroView = [[UIView alloc] initWithFrame:CGRectMake((10/375.0) * kScreenWidth, (620/667.0) * kScreenHeight, flo * (indexPath.row + 1), (3/667.0) * kScreenHeight)];
    self.scroView.backgroundColor = [UIColor orangeColor];
    
    [_imView addSubview:_scrollView];
    [_imView addSubview:view];
    [_imView addSubview:self.scroView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction: )];
//    [_imView addGestureRecognizer:tap];
    
    [self.view addSubview:_imView];

    
//    [[UIApplication sharedApplication].keyWindow addSubview:_imView];

}
- (void)longTap:(UILongPressGestureRecognizer *)longTap{
    WKLog(@"长按了图片。。。");
    
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"下载图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WKLog(@" 执行 下载 ");
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WKLog(@"取消了 下载");
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
}
//删除 显示的图片
- (void)tapAction:(UITapGestureRecognizer *)tap{
    WKLog(@"触摸了屏幕");
//    self.navigationController.navigationBarHidden = NO;
    [_imView removeFromSuperview];
    self.scroView = nil;
 

    CGFloat flo = self.listTableView.contentSize.height /self.dataArray.count;
    //返回到  滚动到的位置
    self.listTableView.contentOffset = CGPointMake( 0, flo * self.scrollView.contentOffset.x/ kScreenWidth - 300);//(300/667.0) * kScreenHeight +
    //这个只是选中
//    NSInteger index = [self.scrollView.contentOffset/ kScreenWidth cgf;
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow: inSection:0];
//    [self.listTableView deselectRowAtIndexPath:indexpath animated:NO];
    // 当前选中
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.listTableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    
 
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    WKLog(@"滚动结束了");
    CGFloat flo =  (kScreenWidth - 20) / self.dataArray.count;
    if (self.scroView) {
        WKLog(@"scroView....滚动结束了");
        self.scroView.frame = CGRectMake((10/375.0) * kScreenWidth, (620/667.0) * kScreenHeight, flo * (scrollView.contentOffset.x / kScreenWidth + 1), (3/667.0) * kScreenHeight);
    }
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    WKRecommendNotesDetailModel *model = self.dataArray[indexPath.row];
//    WKLog(@"%f", [model cellsHeight] + 60);
//    return [model cellsHeight];
//}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    
//    
//    
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    WKLog(@"scollView");
//
//    
//
//    
//    
//    
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 320;
//}

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
