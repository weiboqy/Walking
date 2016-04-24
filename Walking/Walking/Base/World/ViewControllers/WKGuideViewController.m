//
//  WKGuideViewController.m
//  Walking
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKGuideViewController.h"
#import "WKGuideModel.h"

@interface WKGuideViewController ()

/** 数据源 */
@property (strong, nonatomic)NSMutableArray *dataArr;

@end

@implementation WKGuideViewController

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义导航条
    [self addCustomNagationBar];
    
    // 加载数据
    [self parseData];
    
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
// 返回按钮
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

// 加载数据
- (void)parseData {
    // 显示
    WKLog(@"ID = %@", _ID);
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
                for (NSDictionary *detailDic2 in detailDic1[@"phtots"]) {
                    WKGuideDetailPhotoModel *photoModel = [[WKGuideDetailPhotoModel alloc]init];
                    [photoModel setValuesForKeysWithDictionary:detailDic2];
                    sectionsModel.photoModel = photoModel;
                    detailModel.sectionsModel = sectionsModel;
                }
                model.detailModel = detailModel;
                WKLog(@"title = %@", model.title);
                WKLog(@"title1 = %@", model.detailModel.title);
                WKLog(@"title2 = %@", model.detailModel.sectionsModel.title);
                [self.dataArr addObject:model];
            }
            
            
        }
    } error:^(NSError *error) {
        
    }];
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
