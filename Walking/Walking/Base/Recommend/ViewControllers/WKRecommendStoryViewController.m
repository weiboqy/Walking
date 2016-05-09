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
#import "UMSocial.h"
#import "LoginViewController.h"
#import "WKRecommendDB.h"

#define kNavigationAndStatusBarHeihght 64

@interface WKRecommendStoryViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UMSocialUIDelegate>

@property (strong, nonatomic) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) WKStoryListHeadView *headView;

//显示的 内容
@property (nonatomic, copy) NSString *uName;//作者姓名
@property (nonatomic, copy) NSString *avatar_l;//头像
@property (nonatomic, copy) NSString *name;//trip旅行家
@property (nonatomic, copy) NSString *date_added;//时间
@property (nonatomic, copy) NSString *text;//第一条标题

@property (nonatomic, assign) CGFloat flo;

@property (nonatomic, strong) UIView *customNavigationBar;
@property (nonatomic, strong) UIImageView *navigationBangroundImageView;
@property (nonatomic, strong) UILabel *navigationTitle;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIButton *infoButton1;

//点击图片的 方法
@property (nonatomic, strong) UIView *imView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scroView;

//收藏/分享
@property (nonatomic, strong) UIBarButtonItem *itemLove;
@property (nonatomic, assign) BOOL isTure;


@end

static NSString * const imageCellID = @"listCell";

@implementation WKRecommendStoryViewController


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)requestData{
    [SVProgressHUD show];
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:RecommendStoryDetailURL, _spot_id] parDic:@{} finish:^(NSData *data) {
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@", dicData);
        
        NSDictionary *dicT = dicData[@"data"];
        _text = dicT[@"spot"][@"text"];
        _name = dicT[@"trip"][@"name"];
        _date_added = dicT[@"trip"][@"date_added"];
        _uName = dicT[@"trip"][@"user"][@"name"];
        _avatar_l = dicT[@"trip"][@"user"][@"avatar_l"];
        
        for (NSDictionary *dicN in dicT[@"spot"][@"detail_list"]) {
            WKRecommendStoryDetailModel *detailModel = [[WKRecommendStoryDetailModel alloc] init];
//            [detailModel setValuesForKeysWithDictionary:dicT[@"spot"]];
            [detailModel setValuesForKeysWithDictionary:dicN];
            [self.dataArray addObject:detailModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.listTableView reloadData];
            //2016-04-04T13:21:26+08:00
            _headView.timeLabel.text = [NSString stringWithFormat:@"%@", [_date_added substringWithRange:NSMakeRange(0, 10)]];
            _headView.TLabel.text = [NSString stringWithFormat:@"此故事由 %@ 收录于", _uName];
            _headView.titleLabel.text = _name;
            [_headView.icon sd_setImageWithURL:[NSURL URLWithString:_avatar_l] placeholderImage:PLACEHOLDER];
            //有数据了再 指定
            self.listTableView.tableHeaderView = _headView;
        });
        
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
        
        [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
    }];
}

- (void)createListTableView{
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0)];
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    //添加背景图
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = [UIScreen mainScreen].bounds;
    effectview.alpha = 1;
    
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.imageURL]];
        effectview.alpha = 0.5;
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:PLACEHOLDER];
    [imageV addSubview:effectview];
    _bannerImageView = imageV;
    [self.view addSubview:imageV];
    
//    [self.listTableView registerNib:[UINib nibWithNibName:@"WKStoryListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
    [self.listTableView registerClass:[WKStoryListTableViewCell class] forCellReuseIdentifier:imageCellID];
    [self.listTableView registerNib:[UINib nibWithNibName:@"WKStoryListTableViewHeadCell" bundle:nil] forCellReuseIdentifier:@"listHeadCell"];
    //指定头视图
    //xib 指定 不行
    _headView = [[NSBundle mainBundle] loadNibNamed:@"WKStoryListHeadView" owner:nil options:nil].lastObject;
    _headView.frame = CGRectMake(0, 0, 0, 240/667.0 * kScreenHeight);
    [_headView initializeData];
    
  [self.view addSubview:self.listTableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];   
    
    _isTure = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"精选故事";
    
    [self requestData];
    [self createListTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *itemShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    _itemLove = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"五角星（空）"] style:UIBarButtonItemStylePlain target:self action:@selector(love)];
    
    self.navigationItem.rightBarButtonItems = @[itemShare, _itemLove];
    //设置 收藏的 图片的显示状态
    WKRecommendDB *db = [[WKRecommendDB alloc] init];
    NSArray *array = [db findWithID:_spot_id];
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
        NSArray *array = [db findWithID:_spot_id];
        if (!array.count == 0) {
                [db deleteWithTitle:_name];
                [_itemLove setImage:[UIImage imageNamed:@"五角星（空）"]];
                return;
            }
        // 否则，调用保存方法进行存储 http://api.breadtrip.com/v2/new_trip/spot/?spot_id=%@
        [db saveDetailID:_spot_id title:_name imageURL:_imageURL type:@"story"];
        [_itemLove setImage:[UIImage imageNamed:@"五角星（满）"]];
    }else{
        WKLog(@"请先登陆");
        
        LoginViewController *logVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:logVC animated:YES completion:nil];
    }
}



- (void)share{
    WKLog(@"分享");
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"570bb59a67e58e78b30005a0" shareText:[NSString stringWithFormat:@"我在Walking看到一个有趣的游记哦,这是网址:http://chanyouji.com/articles/"] shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToQQ, UMShareToWechatSession, UMShareToWechatTimeline ,UMShareToEmail, UMShareToSms,  UMShareToTencent,nil] delegate:self];

}


-(void)backClick {
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
//        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        WKStoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellID forIndexPath:indexPath];
        if (!cell) {
            cell = [[WKStoryListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.dataArray[indexPath.row];
//        //返回给 cell的高度
//        self.cellHeightBlock = ^(){
//            return cell.cellHeight;
//            WKLog(@"00000%f", cell.cellHeight);
//        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CGSize maxSize = CGSizeMake(kScreenWidth - (10/375.0) * kScreenWidth * 2, MAXFLOAT);
        CGFloat textH = [_text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil].size.height;
//        WKLog(@"%f", textH);
        return (textH + 20);//上下各 10 
    }else{
        WKRecommendStoryDetailModel *detailModel = self.dataArray[indexPath.row ];
//        WKLog(@"cellHeight:%f, model.height:%f", [detailModel cellHeight], detailModel.photo_height);
        return [detailModel cellsHeight];
    }
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
    for (WKRecommendStoryDetailModel *model in self.dataArray) {
        i ++;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i - 1), 0, [UIScreen mainScreen].bounds.size.width, (300 / 667.0) * kScreenHeight)];
        
        //        imageV.height = model.photoModel.h * (kScreenWidth / model.photoModel.w);//可以设置图片的高度
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
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kScreenWidth * (i - 1), (500/ 667.0) * kScreenHeight, kScreenWidth, (110/667.0) * kScreenHeight)];
        textView.backgroundColor = [UIColor blackColor];
        textView.showsVerticalScrollIndicator = NO;
        textView.font = [UIFont systemFontOfSize:14.0];
        textView.text = model.text;
        textView.textColor = [UIColor whiteColor];
        textView.editable = NO;
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.photo_s] placeholderImage:PLACEHOLDER];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
        [imageV addGestureRecognizer:longTap];
        [imageV addGestureRecognizer:tap];
        
        [_scrollView addSubview:textView];
        [_scrollView addSubview:imageV];
    }
    //添加下边的滑动条
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((10/375.0) * kScreenWidth, (630/667.0) * kScreenHeight, kScreenWidth - 20, (3/667.0) * kScreenHeight)];//(620/667.0) * kScreenHeight
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
        NSString *str =  [self.dataArray[count] photo_s];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
