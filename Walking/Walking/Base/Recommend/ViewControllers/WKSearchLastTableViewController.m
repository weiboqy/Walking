//
//  WKSearchLastTableViewController.m
//  Walking
//
//  Created by lanou on 16/4/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKSearchLastTableViewController.h"
#import "WKSearchLastTableViewControllerModel.h"
#import "WKSearchLastTableViewControllerCell.h"


@interface WKSearchLastTableViewController ()


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) WKSearchLastTableViewControllerModel *model;

@end

@implementation WKSearchLastTableViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)requestData{
    [SVProgressHUD show];
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:RecommendSearchLastDetailURL, _ID] parDic:@{} finish:^(NSData *data) {
        
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        WKLog(@"dataDic:%@", dicData);
      
        WKSearchLastTableViewControllerModel *model = [[WKSearchLastTableViewControllerModel alloc] init];
        [model setValuesForKeysWithDictionary:dicData];
       
        _model = model;
//        WKLog(@"model:%@", dicData);
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
    
        });
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        WKLog(@"error%@", error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@", _titles];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WKSearchLastTableViewControllerCell" bundle:nil] forCellReuseIdentifier:@"searchLast"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIImageView *headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220/667.0*kScreenHeight)];


    [headImageV sd_setImageWithURL:[NSURL URLWithString:_headImageURL] placeholderImage:PLACEHOLDER];
    headImageV.contentMode = UIViewContentModeScaleToFill;
    headImageV.clipsToBounds = YES;
    headImageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.tableHeaderView = headImageV;
    
    //去掉 横线
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
//    self.tableView.bounces = NO;
    [self requestData];

    
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
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKSearchLastTableViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchLast" forIndexPath:indexPath];
//    WKSearchLastTableViewControllerModel *model = self.dataArray[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.titileLabel.text = @"概况";
            cell.contentlabel.text = _model.Description;
//            WKLog(@"des:%@", _model.Description);
            break;
        case 1:
            cell.titileLabel.text = @"地址";
            cell.contentlabel.text = _model.address;
            break;
        case 2:
            cell.titileLabel.text = @"行动路线";
            cell.contentlabel.text = _model.arrival_type;
            break;
        case 3:
            cell.titileLabel.text = @"开放时间";
            cell.contentlabel.text = _model.opening_time;
            break;
        case 4:
            cell.titileLabel.text = @"联系电话";
            cell.contentlabel.text = _model.tel;
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
