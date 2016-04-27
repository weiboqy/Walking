//
//  WKGradientNaigationBar.m
//  Walking
//
//  Created by lanou on 16/4/27.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKGradientNaigationBar.h"


#define kNavigationAndStatusBarHeihght 64

@implementation WKGradientNaigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _customNavigationBar = [[UIView alloc]init];
        [self addSubview:_customNavigationBar];
        NSDictionary *views = NSDictionaryOfVariableBindings(_customNavigationBar);
        NSDictionary *metrics = @{@"HN":@(kNavigationAndStatusBarHeihght)};
        NSArray *visualFormats = @[@"H:|[_customNavigationBar]|",
                                   @"V:|[_customNavigationBar(==HN)]"
                                   ];
        [VisualFormatLayout autoLayout:self visualFormats:visualFormats metrics:metrics views:views];
        
        _navigationBangroundImageView = [[UIImageView alloc]init];
        _navigationBangroundImageView.contentMode = UIViewContentModeScaleToFill;
//        UIImage *bannerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.imageURL]]]];
        
//        CGSize bannerImageSize = bannerImage.size;
//        CGFloat bannerNavBGImageHeight = bannerImageSize.width / self.frame.size.width * kNavigationAndStatusBarHeihght;
//        CGRect navigationBackroundImageRect = CGRectMake(0, 0, bannerImageSize.width, bannerNavBGImageHeight);
//        UIImage *bannerNavBGImage = [bannerImage partImageInRect:navigationBackroundImageRect];
//        _navigationBangroundImageView.image = bannerNavBGImage;
        [_customNavigationBar addSubview:_navigationBangroundImageView];
        
        _navigationTitle = [[UILabel alloc]init];
        _navigationTitle.text = @"精彩故事";
        _navigationTitle.textColor = [UIColor whiteColor];
        _navigationTitle.textAlignment = NSTextAlignmentCenter;
        _navigationTitle.font = [UIFont systemFontOfSize:18.0];
        [_customNavigationBar addSubview:_navigationTitle];
        
        
        _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_infoButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        // 自适应尺寸
        //    [_infoButton sizeToFit];
//        [_infoButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [_customNavigationBar addSubview:_infoButton];
        
        views = NSDictionaryOfVariableBindings(_navigationBangroundImageView, _navigationTitle, _infoButton);
        // 使用UIBlurEffect来制作毛玻璃
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = CGRectMake(0, 0, kScreenWidth, 64);
        [_navigationBangroundImageView addSubview:effectView];
        //    _navigationTitle.center = CGPointMake(kScreenWidth / 2, 22);
        //    _navigationTitle.bounds = CGRectMake(0, 0, 100, 30);
        _navigationTitle.frame = CGRectMake(kScreenWidth / 2 - 50, 32, 100, 30);
        
        _navigationTitle.textAlignment = NSTextAlignmentCenter;
        metrics = @{@"WB":@(34)};
        visualFormats =  @[@"H:|[_navigationBangroundImageView]|",
                           @"H:|-[_infoButton(==WB)]-(-20)-[_navigationTitle]|",
                           @"H:|[_infoButton(==60)]|",
                           //                       @"H:|[_navigationTitle(==390)]|",
                           @"V:|[_navigationBangroundImageView]|",
                           @"V:|-[_navigationTitle(==50)]|",
                           @"V:|-[_infoButton(==50)]|"
                           ];
        [VisualFormatLayout autoLayout:_customNavigationBar visualFormats:visualFormats metrics:metrics views:views];
    }
    return  self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
