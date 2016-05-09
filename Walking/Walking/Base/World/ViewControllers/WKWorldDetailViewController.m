//
//  WKWorldDetailViewController.m
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKWorldDetailViewController.h"
#import "WKWorldDetailModel.h"
#import "WKWorldDetailCell.h"
#import "WKCategoryViewController.h"
#import "WKNoGuideCategoryViewController.h"

@interface SDWebImageManager  (cache)


- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url;

@end

@implementation SDWebImageManager (cache)

- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    return ([self.imageCache imageFromMemoryCacheForKey:key] != nil) ?  YES : NO;
}

@end

@interface WKWorldDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArr;

@end

static NSString * const WorldDetailCellID = @"WorldDetailCellID";

@implementation WKWorldDetailViewController

#pragma mark ---懒加载
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorGlobal;
    
    self.navigationController.navigationBarHidden = YES;
    
    [self addCustomNagationBar];
    
    
    [self parseData];
    
    //chuangjian
    [self createListView];
}

- (void)createListView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 隐藏分割线
    self.tableView.separatorStyle = NO;
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKWorldDetailCell class]) bundle:nil] forCellReuseIdentifier:WorldDetailCellID];
    
    [self.tableView registerClass:[WKWorldDetailCell class] forCellReuseIdentifier:WorldDetailCellID];
    
    [self.view addSubview:self.tableView];
}

- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenHeight, 44)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(-10, 10, 70, 30);
    
    // 设置返回按钮的图片
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:button];
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(kScreenWidth / 2 - 50, 8, 100, 30);
    [titleBtn setTitle:_titleName forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [bar addSubview:titleBtn];
    
    [self.view addSubview:bar];
    
//    self.navigationItem.title = _titleName;
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)parseData {
    // 显示指示器
    [SVProgressHUD showInfoWithStatus:@"正在加载哦~~~"];
    
    // id请求参数
//    WKLog(@"%@", _ID);
    
    NSString *url = [NSString stringWithFormat:@"http://chanyouji.com/api/destinations/%@.json?page=1", _ID];
    [NetWorkRequestManager requestWithType:GET urlString:url parDic:@{} finish:^(NSData *data) {
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dic in dataArr) {
                WKWorldDetailModel *model = [[WKWorldDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
                
//                WKLog(@"%@", model.name_zh_cn);
                //            WKLog(@"%ld", self.dataArr.count);
            }
            // 取消指示器
            [SVProgressHUD dismiss];
            
            // 刷新tableView
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

    } error:^(NSError *error) {
        // 失败也取消指示器
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}




#pragma mark ----UITabvleView代理
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKWorldDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:WorldDetailCellID forIndexPath:indexPath];
    WKWorldDetailModel *model = self.dataArr[indexPath.row];
    
    if (![[SDWebImageManager sharedManager] memoryCachedImageExistsForURL:[NSURL URLWithString:model.image_url]]) {
        
        CATransform3D rotation;//3D旋转
        
        rotation = CATransform3DMakeTranslation(0 ,50 ,20);
        //        rotation = CATransform3DMakeRotation( M_PI_4 , 0.0, 0.7, 0.4);
        //逆时针旋转
        
        rotation = CATransform3DScale(rotation, 0.9, .9, 1);
        
        rotation.m34 = 1.0/ -600;
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        
        [UIView beginAnimations:@"rotation" context:NULL];
        //旋转时间
        [UIView setAnimationDuration:0.6];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
    }

    
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WKWorldDetailModel *model = self.dataArr[indexPath.row];
    
    if ([model.name_zh_cn isEqualToString:@"老挝"] || [model.name_zh_cn isEqualToString:@"朝鲜"] || [model.name_zh_cn isEqualToString:@"西安"] || [model.name_zh_cn isEqualToString:@"青海湖及周边"] || [model.name_zh_cn isEqualToString:@"甘南与兰州"] || [model.name_zh_cn isEqualToString:@"呼伦贝尔"] || [model.name_zh_cn isEqualToString:@"额济纳旗"] || [model.name_zh_cn isEqualToString:@"赤峰"] || [model.name_zh_cn isEqualToString:@"呼和浩特"] || [model.name_zh_cn isEqualToString:@"阿尔山"] || [model.name_zh_cn isEqualToString:@"锡林郭勒"] || [model.name_zh_cn isEqualToString:@"乌鲁木齐"] || [model.name_zh_cn isEqualToString:@"喀纳斯"] || [model.name_zh_cn isEqualToString:@"伊犁"] || [model.name_zh_cn isEqualToString:@"吐鲁番"] || [model.name_zh_cn isEqualToString:@"喀什"] || [model.name_zh_cn isEqualToString:@"敦煌与嘉峪关"] || [model.name_zh_cn isEqualToString:@"三亚"] || [model.name_zh_cn isEqualToString:@"新疆"] || [model.name_zh_cn isEqualToString:@"哈尔滨"] || [model.name_zh_cn isEqualToString:@"青岛"] || [model.name_zh_cn isEqualToString:@"洛阳"] || [model.name_zh_cn isEqualToString:@"桂林"] || [model.name_zh_cn isEqualToString:@"凤凰与张家界"] || [model.name_zh_cn isEqualToString:@"婺源"] || [model.name_zh_cn isEqualToString:@"马六甲"] || [model.name_zh_cn isEqualToString:@"民丹岛"] || [model.name_zh_cn isEqualToString:@"龙目岛"] || [model.name_zh_cn isEqualToString:@"加勒及南部海岸"] || [model.name_zh_cn isEqualToString:@"东部海岸"] || [model.name_zh_cn isEqualToString:@"蓝毗尼"] || [model.name_zh_cn isEqualToString:@"琅勃拉邦及北部"] || [model.name_zh_cn isEqualToString:@"万象和万荣"] || [model.name_zh_cn isEqualToString:@"里昂"] || [model.name_zh_cn isEqualToString:@"马特洪峰与瓦莱州"] || [model.name_zh_cn isEqualToString:@"美国"] || [model.name_zh_cn isEqualToString:@"洛杉矶"] || [model.name_zh_cn isEqualToString:@"旧金山"] || [model.name_zh_cn isEqualToString:@"拉斯维加斯"] || [model.name_zh_cn isEqualToString:@"纽约"] || [model.name_zh_cn isEqualToString:@"华盛顿"] || [model.name_zh_cn isEqualToString:@"黄石国家公园"] || [model.name_zh_cn isEqualToString:@"西雅图"] || [model.name_zh_cn isEqualToString:@"芝加哥"] || [model.name_zh_cn isEqualToString:@"迈阿密"]) {
        WKNoGuideCategoryViewController *noGuideCategoryVC = [[WKNoGuideCategoryViewController alloc]init];
        noGuideCategoryVC.model = model;
        noGuideCategoryVC.ID = model.ID;
        [self.navigationController pushViewController:noGuideCategoryVC animated:YES];
    } else {
        WKCategoryViewController *categoryVC = [[WKCategoryViewController alloc]init];
        categoryVC.model = model;
        categoryVC.ID = model.ID;
        [self.navigationController pushViewController:categoryVC animated:YES];
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
