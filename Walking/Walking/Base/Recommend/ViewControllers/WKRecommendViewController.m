//
//  WKRecommendViewController.m
//  Walking
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendViewController.h"
#import "WKListTableViewCell.h"
#import "WKRecommendView.h"
#import "WKRecommendCollectionViewCell.h"
#import "WKRecommendNotesViewController.h"
#import "WKRecommendStoryViewController.h"



#define kStr @"reuse"

@interface WKRecommendViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) WKRecommendView *headView;
@property (nonatomic, assign) NSInteger index;


@end


@implementation WKRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"推荐";
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self createListTableView];
    _index = 0;

    self.view.backgroundColor = ColorGlobal;

    // Do any additional setup after loading the view from its nib.
//    
//    UIView *head = [[UIView alloc] initWithFrame:CGRectZero];
////    head.layer.cornerRadius = 90;
//    
//    head.backgroundColor = [UIColor redColor];
//    [self.view addSubview:head];
//    
//    [UIView animateWithDuration:3.0 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionOverrideInheritedOptions animations:^{
//        
//        head.layer.cornerRadius = 50;
//        head.frame = CGRectMake(100, 500, 100, 100);
//    } completion:nil];
}


- (void)listTableViewHeadView{
    
    CGFloat with = [[UIScreen mainScreen] bounds].size.width;
    self.headView = [[WKRecommendView alloc] initWithFrame:CGRectMake(0, 0, with, 570)];
    self.headView.backgroundColor = [UIColor colorWithRed:0.948 green:0.967 blue:0.90 alpha:1.0];
    self.listTableView.tableHeaderView = self.headView;
    
   //1 设置头视图轮播图
    
        NSMutableArray *viewArray = [@[] mutableCopy];
        for (int i = 0; i < 3; i ++) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame: self.headView.headScrolView.bounds];
            imageV.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1.0];
            [viewArray addObject:imageV];
        }
        //2 设置轮播的图片
         self.headView.headScrolView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewArray[pageIndex];
        };
         self.headView.headScrolView.totalPagesCount = 3;
    
        //3 这个是点击图片的的触发方法
         self.headView.headScrolView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了：%ld", (long)pageIndex);
        };
    //2 moreButton
    [self.headView.moreButton addTarget:self action:@selector(button) forControlEvents:UIControlEventTouchUpInside];
    
    //3 设置collection
    [self.headView.collectionView registerNib:[UINib nibWithNibName:@"WKRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kStr];
    
    self.headView.collectionView.delegate = self;
    self.headView.collectionView.dataSource = self;
// [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2500 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
   
}
//更多的点击方法
- (void)button{
//    NSLog(@"moreButton");
    if (self.headView.collectionView.contentOffset.x  > self.headView.collectionView.contentSize.width - 375 + 20) {
         [self.headView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        return;
    }
    //滚动的  item
    CGPoint p = self.headView.collectionView.contentOffset;
    p = CGPointMake((375-20 + 10) + p.x, 0);
    [self.headView.collectionView setContentOffset:p animated:YES];
}

#pragma mark ---collectionView----
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((375-20-10)/ 2, 160);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WKRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStr forIndexPath:indexPath];
    cell.userName.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld, %ld", indexPath.section, indexPath.row);
    
    WKRecommendStoryViewController *storyVc = [[WKRecommendStoryViewController alloc] init];
    [self.navigationController pushViewController:storyVc animated:YES];
    
}

- (void)createListTableView{
    
    self.listTableView.delegate   = self;
    self.listTableView.dataSource = self;
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"WKListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    [self listTableViewHeadView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WKListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = @"001";
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", indexPath.row);
    
    WKRecommendNotesViewController *notesVc = [[WKRecommendNotesViewController alloc] init];
    [self.navigationController pushViewController:notesVc animated:YES];
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
