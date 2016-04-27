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

@interface WKTravelNoteDetailViewController ()

@property (strong, nonatomic)NSMutableArray *headerDataArr;
@property (strong, nonatomic)NSMutableArray *dataArr;

@end

@implementation WKTravelNoteDetailViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorGlobal;
    
    [self loadData];
    
    [self addCustomNagationBar];
    // Do any additional setup after loading the view from its nib.
}

- (void)addCustomNagationBar {
    // NavigationBar
    WKNavigtionBar *bar = [[WKNavigtionBar alloc]initWithFrame:CGRectMake(0, 20, kScreenHeight, 44)];
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

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadData {
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://chanyouji.com/api/trips/%@.json", _ID] parDic:@{} finish:^(NSData *data) {
        NSDictionary *DataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        WKLog(@"%@", DataDic);
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
        WKLog(@"Note desc = %@", noteModel.notesModel.descriptioN);
        
        
        for (NSDictionary *dic in tripArr) {
            NSArray *arr = dic[@"nodes"];
            for (int i = 1; i < arr.count; i ++) {
                NSDictionary *dic1 = arr[i];
                NSArray *arr1 = dic1[@"notes"];
                for (NSDictionary *dic2 in arr1) {
                    WKNoteModel *descModel = [[WKNoteModel alloc]init];
                    [descModel setValuesForKeysWithDictionary:dic2];
                    for (NSDictionary *dic3 in dic2[@"photo"]) {
                        WKTravelPhotoModel *photoModel = [[WKTravelPhotoModel alloc]init];
                        [photoModel setValuesForKeysWithDictionary:dic3];
                        descModel.photoModel = photoModel;
                        [self.dataArr addObject:descModel];
                        WKLog(@"desc DESC = %@", descModel.descriptioN);
                    }
                }
            }
        }
        
//        for (NSDictionary *dic in tripArr) {
//            for (NSDictionary *dic1 in dic[@"nodes"]) {
//                for (NSDictionary *dic2 in dic1[@"notes"]) {
//                    WKNoteModel *descModel = [[WKNoteModel alloc]init];
//                    [descModel setValuesForKeysWithDictionary:dic2];
//                    for (NSDictionary *dic3 in dic2[@"photo"]) {
//                        WKTravelPhotoModel *photoModel = [[WKTravelPhotoModel alloc]init];
//                        [photoModel setValuesForKeysWithDictionary:dic3];
//                        descModel.photoModel = photoModel;
//                        [self.dataArr addObject:descModel];
//                        WKLog(@"%@", descModel.descriptioN);
//                    }
//                }
//            }
//            
//        }
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
