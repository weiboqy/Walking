//
//  WKImageSwitchView.m
//  Walking
//
//  Created by lanou on 16/4/23.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKImageSwitchView.h"

@implementation WKImageSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _imageScrollView.frame = CGRectMake(0, 0, self.width, self.height);
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.bounces = NO;
        _imageScrollView.delegate = self;
        [self addSubview:_imageScrollView];
    }
    return self;
}

//  根据图片的数组来决定图片在滚动视图上的位置，以及传入的代理对象
- (void)setImageSwitchViewArray:(NSArray *)imageSwitchViewArray delegate:(id)delegate {
    _delegate = delegate;
    
    float space = 0;// 图片与图片间的间隔
    float width = 0;
    float viewWidth = 0;
    for (UIView *view in imageSwitchViewArray) {
        
        // 数组中当前图片的下标
        NSInteger index = [imageSwitchViewArray indexOfObject:view];
        if (index == 0) {
            // 取得图片的宽度
            viewWidth = view.frame.size.width;
        }
        space = (self.frame.size.width - viewWidth) / 4;
        // 图片在滚动视图上的位置
        view.frame = CGRectMake(space * 2 + (view.frame.size.width + space) * index, 0, viewWidth, view.frame.size.height);
        width = viewWidth + space;
        CGFloat x = index * width;
        CGFloat value = (0 - x) / (width);
        CGFloat scale = fabs(cos(fabs(value) * M_PI / 5));//缩小比例
        
        view.transform = CGAffineTransformMakeScale(1.0, scale);
        
//        WKLog(@"%@",NSStringFromCGRect(view.frame));
        
        [_imageScrollView addSubview:view];
      
    }
    
    _imageScrollView.contentSize = CGSizeMake((space * 2 + width * imageSwitchViewArray.count) + space, _imageScrollView.frame.size.height);
}

//  让图片处于中心的方法
- (void)scrollToViewCenter {
    float space = 0;
    float viewWidth = 0;
    for (UIView *view in _imageScrollView.subviews) {
        NSInteger index = [_imageScrollView.subviews indexOfObject:view];
        if (index == 0) {
            viewWidth = view.frame.size.width;
        }
        space = (self.frame.size.width - viewWidth) / 4;
    }
    [_imageScrollView scrollRectToVisible:CGRectMake(_currentIndex * (viewWidth + space), 0, _imageScrollView.frame.size.width, _imageScrollView.frame.size.height) animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(imageSwitchViewDidScroll:index:)]) {
        [_delegate imageSwitchViewDidScroll:self index:_currentIndex];
    }
}

#pragma mark -代理方法-

//  正在滚动触发的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollView.subviews----->%@",scrollView.subviews);
//    NSLog(@"%f",scrollView.contentOffset.x);
    //获取偏移量
    CGFloat offset = scrollView.contentOffset.x;
    if (offset < 0 || (offset > scrollView.contentSize.width - self.frame.size.width)) {
        return;
    }
    
    float space = 0;
    float viewWidth = 0;
    for (UIView *view in _imageScrollView.subviews) {
        NSInteger index = [_imageScrollView.subviews indexOfObject:view];
        if (index == 0) {
            viewWidth = view.frame.size.width;
        }
        space = (self.frame.size.width - viewWidth) / 4;
        CGFloat width = viewWidth + space;
        CGFloat x = index * width;
        CGFloat value = (offset - x) / width;
        CGFloat scale = fabs(cos(fabs(value) * M_PI / 5));
        
        view.transform = CGAffineTransformMakeScale(1.0, scale);
    }
    
    float w = offset / (viewWidth + space);
    
    if (w - (int)w > 0.5) {
        _currentIndex = (int)w + 1;
    } else {
        _currentIndex = (int)w;
    }
}

//  停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self scrollToViewCenter];
}

//  滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToViewCenter];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
