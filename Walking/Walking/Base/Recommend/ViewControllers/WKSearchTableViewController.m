//
//  WKSearchTableViewController.m
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSearchTableViewController.h"
#import "WKSearchTableViewCell.h"
#import "NetWorkRequestManager.h"
#import "WKRecommendSearchModel.h"
#import "WKRecommendSearchCityModel.h"
#import "WKRecommendNotesViewController.h"
#import "WKSearchDetailViewController.h"

@interface WKSearchTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, assign) NSInteger start;

@property (nonatomic, strong) UIView *headView;


@end

@implementation WKSearchTableViewController

- (NSMutableArray *)cityArray{
    if (!_cityArray) {
        self.cityArray = [NSMutableArray array];
    }
    return  _cityArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
//汉字转化为拼音
- (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSArray *array = [pinyin componentsSeparatedByString:@" "];
    NSString *newStr = [array componentsJoinedByString:@""];
    
//    NSLog(@"%@", pinyin);
    return newStr;//
}

- (void)requestDataWithStart:(NSInteger)start{
//    WKLog(@"keyStr:%@", _keyStr);//
    [SVProgressHUD show];
    NSString *URL = [self transform:_keyStr];
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:RecommendSearchURL, URL, @(start)] parDic:@{} finish:^(NSData *data) {
        
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dataDic:%@", dicData);
        if (_start == 0 & self.dataArray.count != 0) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in dicData[@"trips"]) {
            WKRecommendSearchModel *searchModel = [[WKRecommendSearchModel alloc] init];
            [searchModel setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:searchModel];
        }
//        NSLog(@"%@",dicData[@"places"]);
        for (NSDictionary *dics in dicData[@"places"]) {
            WKLog(@"dics:%@", dics[@"name"]);
            WKRecommendSearchCityModel *searchCityModel = [[WKRecommendSearchCityModel alloc] init];
            [searchCityModel setValuesForKeysWithDictionary:dics];
            [self.cityArray addObject:searchCityModel];
        }
        
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        });
        [SVProgressHUD dismiss];
        
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败！"];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorGlobal;
    _start = 0;
    
//    WKLog(@"keyStr:%@", self.keyStr);
//    self.tableView.frame.size.height = [UIScreen mainScreen].bounds.size.height - 64;
    [self.tableView registerNib:[UINib nibWithNibName:@"WKSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier: @"searchCells"];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self requestDataWithStart:0];

}

- (void)loadNewData{
    WKLog(@"下啦开始");
    _start = 0;
    [self requestDataWithStart:_start];
}

- (void)loadMoreData{
    _start += 20;
    [self requestDataWithStart:_start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
//        static NSString *reuse = @"searchCells";
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"searchCells" forIndexPath:indexPath];
       
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCells"];
        }
        WKRecommendSearchModel *model = [self.cityArray firstObject];
        cell.textLabel.text = [NSString stringWithFormat:@"%@  简介", model.name];
        cell.textLabel.textColor = [UIColor orangeColor];
//        cell.detailTextLabel.text = @"简介";
//        cell.detailTextLabel.textColor = [UIColor orangeColor];
        cell.textLabel.font = [UIFont systemFontOfSize:21];
        cell.backgroundColor = ColorGlobal;
        return cell;
        
    }else{
   
    WKSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    WKRecommendSearchModel *model = self.dataArray[indexPath.row];
   cell.titleLabel.text =  model.name;
   [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.cover_image] placeholderImage:PLACEHOLDER];
   cell.dayLabel.text = [NSString stringWithFormat:@"%@天", model.day_count];
    return cell;
        
   }
        
}
//跳转到游记界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WKSearchDetailViewController *detailVc = [[WKSearchDetailViewController alloc] init];
        WKRecommendSearchCityModel *model = [self.cityArray firstObject];
        detailVc.ID = model.ID;
        detailVc.titles = model.name;
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }else{
        WKRecommendNotesViewController *notesVc = [[WKRecommendNotesViewController alloc] init];
        notesVc.ID = [self.dataArray[indexPath.row] ID];
        [self.navigationController pushViewController:notesVc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 100;
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
