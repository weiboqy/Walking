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
#import "UMSocial.h"
#import "WKRecommendDB.h"
#import "LoginViewController.h"

#define kNavigationAndStatusBarHeihght 64

@interface WKRecommendNotesViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UMSocialUIDelegate>

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

//收藏分享
@property (nonatomic, strong) UIBarButtonItem *itemLove;
@property (nonatomic, assign) BOOL isTure;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation WKRecommendNotesViewController


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)requestData{
    
    WKLog(@"%@", _ID);
    [SVProgressHUD show];
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:RecommendTableViewDetailURL, _ID] parDic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        WKLog(@"dic:%@", dic);
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
                [model setValuesForKeysWithDictionary:dicc];
//                WKLog(@"w - h：%@", dicc[@"photo_info"]);
#pragma mark---------bug完美解决-------
                if ([dicc[@"photo_info"] isKindOfClass:[NSDictionary class]]) {
                    [photoModel setValuesForKeysWithDictionary:(NSDictionary *)dicc[@"photo_info"]];
                }
            
                [model setValuesForKeysWithDictionary:dicT];
                model.photoModel = photoModel;
                [self.dataArray addObject:model];
            }
        }
         
//        WKLog(@"photoModel:%f", [[self.dataArray[0] photoModel] h]);
         dispatch_async(dispatch_get_main_queue(), ^{
            
            [self createListTableView];

          //头视图 的空间 赋值
            [self.listTableView reloadData];
//             
            self.headView.titleLabel.text = _name;
            [self.headView.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _imageT]] placeholderImage:PLACEHOLDER];
            [self.headView.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _avatar_m]] placeholderImage:PLACEHOLDER];
//            WKLog(@"%@", _uName);
            self.headView.nameLabel.text = [NSString stringWithFormat:@"By:%@", _uName];
            NSArray *strArray = [(NSString *)[NSString stringWithFormat:@"%@", _mileage] componentsSeparatedByString:@"."];
            self.headView.motersLabel.text = strArray[0];
            self.headView.daysLabel.text = [NSString stringWithFormat:@"%@", _day_count];
            self.headView.lovesLabel.text = [NSString stringWithFormat:@"%@",  _recommendations];
        });

        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        WKLog(@"error:%@", error);
        [SVProgressHUD showErrorWithStatus:@"加载失败!"];
    }];
}
////拖拽结束的方法
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    
//    
//}
- (void)createListTableView{
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0)];
    
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"WKNotesListTableViewCell" bundle:nil] forCellReuseIdentifier:@"notesReuse"];
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"WKNotesListHeadView" owner:nil options:nil] lastObject];
    _headView.backgroundColor = ColorGlobal;
    _headView.frame = CGRectMake(0, 0, kScreenWidth, (345/667.0) * kScreenHeight);
    [_headView handleImage];//处理图片
    self.listTableView.tableHeaderView = _headView;

    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = 20;
//
    [self.view addSubview:self.listTableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = ColorGlobal;
    self.title = @"精选游记";

    [self requestData];

    UIBarButtonItem *itemShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    _itemLove = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"五角星（空）"] style:UIBarButtonItemStylePlain target:self action:@selector(love)];
    
    self.navigationItem.rightBarButtonItems = @[itemShare, _itemLove];
    
    WKRecommendDB *db = [[WKRecommendDB alloc] init];
    NSArray *array = [db findWithID:_ID];
    if (!array.count == 0) {
        [_itemLove setImage:[UIImage imageNamed:@"五角星（满）"]];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)love{
    WKLog(@"收藏");
    
    if (![[UserInfoManager getUserID] isEqualToString:@" "]) {
        // 创建数据表
        WKRecommendDB *db = [[WKRecommendDB alloc] init];
        [db createDataTable];
        // 查询数据是否存储，如果存储就取消存储
        NSArray *array = [db findWithID:_ID];
        if (!array.count == 0) {
            [db deleteWithTitle:_name];
            [_itemLove setImage:[UIImage imageNamed:@"五角星（空）"]];
            return;
        }
        // 否则，调用保存方法进行存储  http://api.breadtrip.com/trips/%@/waypoints/?gallery_mode=1&sign=a4d6a98d84562c66533a3eb834500ee1
        [db saveDetailID:_ID title:_name imageURL:_cover_image type:@"travel"];
        [_itemLove setImage:[UIImage imageNamed:@"五角星（满）"]];
    }else{
        WKLog(@"请先登陆");
        LoginViewController *logVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:logVC animated:YES completion:nil];
    }
}


- (void)share{
    WKLog(@"分享");
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"570bb59a67e58e78b30005a0" shareText:[NSString stringWithFormat:@"我在Walking看到一个有趣的游记哦,这是网址:http://chanyouji.com/articles/"] shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToQQ, UMShareToQzone,UMShareToWechatSession, UMShareToWechatTimeline ,UMShareToEmail, UMShareToSms, UMShareToDouban, UMShareToTencent,nil] delegate:self];
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
    

    _imView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _imView.backgroundColor = [UIColor blackColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * self.dataArray.count, 0);
    _scrollView.pagingEnabled = YES;
     _scrollView.bounces = NO;
    //设置偏移量
    _scrollView.contentOffset = CGPointMake(kScreenWidth * indexPath.row, 0);
//    scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    CGFloat flo =  (kScreenWidth - 20) / self.dataArray.count;

//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        WKLog(@"imageV 多线程操作");
    
    int i = 0;
    for (WKRecommendNotesDetailModel *model in self.dataArray) {
        i ++;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * (i - 1), 0, kScreenWidth, (300 / 667.0) * kScreenHeight)];
        
#pragma mark ---- Can't achieve---------
        //剪切设置尺寸 多余的 暂时没有效果
        imageV.contentMode =  UIViewContentModeScaleToFill;
        imageV.clipsToBounds = YES;
        imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //设置 中心位置
        CGPoint imageVp = imageV.center;
        CGFloat p = _scrollView.center.y;
        imageVp.y = p;
        imageV.center = imageVp;
        //(500/ 667.0) * kScreenHeight
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(kScreenWidth * (i - 1), (500/ 667.0) * kScreenHeight, kScreenWidth, (110/667.0) * kScreenHeight)];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.font = [UIFont systemFontOfSize:14.0];
        _textView.text = model.text;
        _textView.textColor = [UIColor whiteColor];
        _textView.editable = NO;
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:PLACEHOLDER];

        imageV.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
            [imageV addGestureRecognizer:longTap];
            [imageV addGestureRecognizer:tap];
            [_scrollView addSubview:_textView];
            [_scrollView addSubview:imageV];
        
    }
        
 
    
    
    //添加下边的滑动条(620/667.0) * kScreenHeight
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((10/375.0) * kScreenWidth, (630/667.0) * kScreenHeight, kScreenWidth - 20, (3/667.0) * kScreenHeight)];
    view.backgroundColor = [UIColor grayColor];
    self.scroView = [[UIView alloc] initWithFrame:CGRectMake((10/375.0) * kScreenWidth, (630/667.0) * kScreenHeight, flo * (indexPath.row + 1), (3/667.0) * kScreenHeight)];
    self.scroView.backgroundColor = [UIColor orangeColor];
    
    [_imView addSubview:_scrollView];
    [_imView addSubview:view];
    [_imView addSubview:self.scroView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_imView];

//    [self.view addSubview:_imView];
}
- (void)longTap:(UILongPressGestureRecognizer *)longTap {
    WKLog(@"长按了图片。。。");
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WKLog(@" 执行 下载 ");
        
        NSInteger count =  self.scrollView.contentOffset.x/kScreenWidth;//从 0 开始的整数
        //保存到相册
        UIImageView *imageVV = [[UIImageView alloc] init];
        NSString *str =  [self.dataArray[count] photo];
        [imageVV sd_setImageWithURL:[NSURL URLWithString:str]];
        UIImageWriteToSavedPhotosAlbum(imageVV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WKLog(@" 相 册 ");
        //点击相册的按钮 之后执行的方法
        UIImagePickerController *pickerV = [[UIImagePickerController alloc] init];
        pickerV.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//指定弹出的类型
        pickerV.delegate = self;
        pickerV.allowsEditing = YES;//打开相册选取是  对照片的编辑是否打开
        [self presentViewController:pickerV animated:YES completion:nil];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WKLog(@"取消了 下载");
    }];
    
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160/375.0 * kScreenWidth, 120/375.0 * kScreenWidth)];
        view.layer.cornerRadius = 8/375.0 * kScreenWidth;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor grayColor];
        CGPoint p =  _imView.center;
        view.center = p;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100/375.0 * kScreenWidth, 30/667.0 *kScreenHeight)];
        label.text = @"保存成功!";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13/375.0 * kScreenWidth];

        label.center = p;
        [_imView addSubview:view];
        [_imView addSubview:label];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
//            WKLog(@"000000miao");
            [view removeFromSuperview];
            [label removeFromSuperview];
        });
        WKLog(@"添加成功到 相册");
        
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120/375.0 * kScreenWidth, 120/375.0 * kScreenWidth)];
        view.layer.cornerRadius = 8/375.0 * kScreenWidth;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor grayColor];
        CGPoint p =  _imView.center;
        view.center = p;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100/375.0 * kScreenWidth, 30/667.0 *kScreenHeight)];
        label.text = @"保存失败!";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13/375.0 * kScreenWidth];
        //        label.backgroundColor = [UIColor yellowColor];
        label.center = p;
        [_imView addSubview:view];
        [_imView addSubview:label];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            //            WKLog(@"000000miao");
            [view removeFromSuperview];
            [label removeFromSuperview];
        });
        WKLog(@"添加失败");
    }
}
//删除 显示的图片
- (void)tapAction:(UITapGestureRecognizer *)tap{
//    WKLog(@"触摸了屏幕");
//    self.navigationController.navigationBarHidden = NO;
    [_imView removeFromSuperview];
    self.scroView = nil;

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    WKLog(@"滚动结束了");
    
    CGFloat flo =  (kScreenWidth - 20) / self.dataArray.count;
    if (self.scroView) {
        WKLog(@"scroView....滚动结束了");
        self.scroView.frame = CGRectMake((10/375.0) * kScreenWidth, (630/667.0) * kScreenHeight, flo * (scrollView.contentOffset.x / kScreenWidth + 1), (3/667.0) * kScreenHeight);
    }
}

//#warning =--------has wenti--------
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    WKRecommendNotesDetailModel *model = self.dataArray[indexPath.row];
//    return  [model cellsHeightWithImageH:model.photoModel.h imageW:model.photoModel.w  textStr:model.text];//
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
