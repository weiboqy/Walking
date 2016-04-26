//
//  WKStoryListTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKStoryListTableViewCell.h"


@implementation WKStoryListTableViewCell

//压缩图片
- (UIImage *)image:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
- (CGFloat)getImageViewHeight: (float)width_ andHeigeht_:(float)height_
{
    return 260 * height_ / width_;
}

/*
 + (CGFloat)heightForString:(NSString *)string{
 
 NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil];
 CGRect rect = [string boundingRectWithSize:CGSizeMake(3 * kImageWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
 
 return rect.size.height;
 }
 
 */

#warning mark-----------imageView--------
- (void)setDetailModel:(WKRecommendStoryDetailModel *)detailModel{
    _detailModel = detailModel;
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:detailModel.photo_s] placeholderImage:PLACEHOLDER];
//    _imageV.bounds.size.height = 
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _titleLabel.text = detailModel.text;
    
}

- (void)awakeFromNib {
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
