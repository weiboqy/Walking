//
//  WKTravelNoteViewController.m
//  Walking
//
//  Created by lanou on 16/4/26.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKTravelNoteViewController.h"

@interface WKTravelNoteViewController ()

@end

@implementation WKTravelNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self parseData];
    // Do any additional setup after loading the view from its nib.
}

- (void)parseData {
    [NetWorkRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://chanyouji.com/api/destinations/trips/%@.json?month=0&page=1", _ID] parDic:@{} finish:^(NSData *data) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        WKLog(@"%@", arr);
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
