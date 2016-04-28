//
//  WKRecommendCollectionViewCell.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKRecommendCollectionViewCell.h"

@implementation WKRecommendCollectionViewCell


- (void)setStoryModel:(WKRecommendStoryModel *)storyModel{
    _storyModel = storyModel;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:storyModel.cover_image] placeholderImage:PLACEHOLDER];
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:storyModel.cover] placeholderImage:PLACEHOLDER];
    self.userName.text = storyModel.name;     
}

- (void)awakeFromNib {
    
    self.imageV.layer.cornerRadius = 6;
    self.imageV.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius   = 13;
    self.icon.layer.masksToBounds = YES;
    
    self.backImageV.layer.cornerRadius = 10;
    self.backImageV.layer.masksToBounds = YES;
}

@end
