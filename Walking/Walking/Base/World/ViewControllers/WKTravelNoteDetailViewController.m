//
//  WKTravelNoteDetailViewController.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKTravelNoteDetailViewController.h"
#import "WKTravelNoteModel.h"
#import "WKTravelDetailModel.h"
#import "WKTravleDetailCell.h"

#define kNavigationAndStatusBarHeihght 64

@interface WKTravelNoteDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)NSMutableArray *headerDataArr;
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic)NSMutableArray *arr;
@property (strong, nonatomic)UITableView *tableView;

@property (nonatomic, strong) UIView *customNavigationBar;
@property (nonatomic, strong) UIImageView *navigationBangroundImageView;
@property (nonatomic, strong) UILabel *navigationTitle;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIButton *infoButton1;

@property (strong, nonatomic) UIButton *share;



@end

// 标识符
static NSString * const TableViewCellID = @"TableViewCellID";

@implementation WKTravelNoteDetailViewController

#pragma mark ----懒加载
- (NSMutableArray *)headerDataArr {
    if (_headerDataArr == nil) {
        _headerDataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _headerDataArr;
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableArray *)arr {
    if (!_arr) {
        _arr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorGlobal;
    
    // 加载数据
    [self loadData];
    
    // 自定义透明导航条
    [self buildNavigationBar];
    
    // 创建列表
    [self setupSubViews];
    // Do any additional setup after loading the view from its nib.
}



// jiazai数据
- (void)loadData {
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://chanyouji.com/api/trips/%@.json", _ID] parDic:@{} finish:^(NSData *data) {
        NSDictionary *DataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        WKTravelNoteModel *noteModel = [[WKTravelNoteModel alloc]init];
        [noteModel setValuesForKeysWithDictionary:DataDic];
        NSArray *tripArr = DataDic[@"trip_days"];
        NSDictionary *headerDic = tripArr[0];
        NSDictionary *headerDic1 = headerDic[@"nodes"][0];
        NSArray *headerArr = headerDic1[@"notes"];
        NSDictionary *headerDic2 = headerArr[0];
        WKTravleNotesModel *notesModel = [[WKTravleNotesModel alloc]init];
        [notesModel setValuesForKeysWithDictionary:headerDic2];
        noteModel.notesModel = notesModel;
//        WKLog(@"Note desc = %@", noteModel.notesModel.descriptioN);
        
        
        for (NSDictionary *dic in tripArr) {
            for (NSDictionary *dic1 in dic[@"nodes"]) {
                WKTravelDetailModel *notesModel = [[WKTravelDetailModel alloc]init];
                [notesModel setValuesForKeysWithDictionary:dic1];
                [self.arr addObject:notesModel];
                for (NSDictionary *dic2 in dic1[@"notes"]) {
                    WKNoteModel *descModel = [[WKNoteModel alloc]init];
                    [descModel setValuesForKeysWithDictionary:dic2];
                    NSDictionary *photoDic = dic2[@"photo"];
                    WKTravelPhotoModel *photoModel = [[WKTravelPhotoModel alloc] init];
                    [photoModel setValuesForKeysWithDictionary:photoDic];
                    descModel.photoModel = photoModel;
//                    WKLog(@"desc = %@", descModel.descriptioN);
//                    WKLog(@"photo - %@", photoModel.url);
                    [self.dataArr addObject:descModel];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    } error:^(NSError *error) {
        
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
    WKLog(@"infoButton frame %@", NSStringFromCGRect(_infoButton.frame));
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
    
    _navigationTitle.textAlignment = NSTextAlignmentCenter;
    
    _share = [UIButton buttonWithType:UIButtonTypeCustom];
    _share.frame = CGRectMake(kScreenWidth - 60, 10, 40, 30);
    [_share setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [_share addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationTitle addSubview:_share];

    
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
// 导航条随着滚动而透明度变化
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
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
// 返回按钮
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
// 分享按钮
- (void)shareClick {
    
}

- (void) setupSubViews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180) ];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _image_url]]]];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 300, 25)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = [NSString stringWithFormat:@"%@", _name_zn];
    nameLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:nameLabel];
    UILabel *daysLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, 90, 20)];
    daysLabel.text = [NSString stringWithFormat:@"%@天/", _model.start_date];
    daysLabel.font = [UIFont systemFontOfSize:12];
    daysLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:daysLabel];
    
    UILabel *countsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(daysLabel.frame) + 4, 130, 100, 20)];
    countsLabel.font = [UIFont systemFontOfSize:12];
    countsLabel.text = [NSString stringWithFormat:@"%@图", _model.photos_count];
    countsLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:countsLabel];
    _bannerImageView = imageView;
    [bgView addSubview:imageView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = bgView;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKTravleDetailCell class]) bundle:nil] forCellReuseIdentifier:TableViewCellID];
    [self.view addSubview:self.tableView];
}

#pragma mark  ---UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arr.count == 0) {
        return 0;
    }
    return self.arr.count - 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 350 / 667.0 * kScreenHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKTravleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellID forIndexPath:indexPath];
    WKNoteModel *noteModel = self.dataArr[indexPath.row + 1];
    WKTravelDetailModel *detailModel = self.arr[indexPath.row + 1];
    
    if (detailModel.entry_name == nil) {
        cell.nameLabel.text = [NSString stringWithFormat:@"围脖"];
    }else {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",detailModel.entry_name];
    }
   
    cell.textsLabel.text = [NSString stringWithFormat:@"%@", noteModel.descriptioN];
//    WKLog(@"desc = %@", noteModel.descriptioN);
    [cell.textImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", noteModel.photoModel.url]] placeholderImage:PLACEHOLDER];
    cell.textImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.textImageView.clipsToBounds = YES;
    cell.textImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _urlStr = noteModel.photoModel.url;
            
    // 添加轻拍手势
    cell.textImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [cell.textImageView addGestureRecognizer:tap];
    
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
    _imageView1 = imageView;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
}
// 缩放手势
- (void)pinchClick:(UIPinchGestureRecognizer *)pinch {
    //获取要进行缩放的视图
    _imageView1 = (UIImageView *)pinch.view;
    _imageView1.transform = CGAffineTransformScale(_imageView1.transform, pinch.scale, pinch.scale);  //以imageV.transform为基础
    pinch.scale = 1;
}
// 轻拍手势
- (void)tapAction {
    [_bgView removeFromSuperview];
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
