//
//  WKNotesListTableViewCell.m
//  Walking
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "WKNotesListTableViewCell.h"
#define Margin 10
@implementation WKNotesListTableViewCell

/*
 @property (strong, nonatomic) IBOutlet UILabel *dayTimeLabel;
 @property (strong, nonatomic) IBOutlet UIImageView *imageV;
 @property (strong, nonatomic) IBOutlet UILabel *contentLabel;
 @property (strong, nonatomic) IBOutlet UILabel *timeLabel;
 */
- (void)setDetailModel:(WKRecommendNotesDetailModel *)detailModel
{
    _detailModel = detailModel;
    NSString *str = [(NSString *)detailModel.date substringFromIndex:5];
    _dayTimeLabel.text = [NSString stringWithFormat:@"第%@天 %@", detailModel.DAY, str];
    _timeLabel.text = [NSString stringWithFormat:@"%@", detailModel.date];

    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", detailModel.photo]] placeholderImage:PLACEHOLDER];
    _imageV.layer.cornerRadius = 6;
    _imageV.layer.masksToBounds = YES;
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _imageV.userInteractionEnabled = YES;
    
    _contentLabel.text = [NSString stringWithFormat:@"%@", detailModel.text];
    self.imageC.layer.cornerRadius = 6;
    self.imageC.layer.masksToBounds = YES;
    
}

//  返回cell的高度
- (CGFloat)cellsHeight{
//    if (!self.detailModel.photo) {
    
    CGFloat imageH = self.detailModel.photoModel.h;
    CGFloat imageW = self.detailModel.photoModel.w;
        if (![self.detailModel.photo isEqualToString:@""]) {
            if ( self.detailModel.photoModel.w > (kScreenWidth - Margin * 2)) {
                imageH =  self.detailModel.photoModel.h * (kScreenWidth - Margin * 2) / imageW;
                imageW = kScreenWidth - Margin * 2;
            }
//            _imageFrame = CGRectMake(Margin, Margin/2, imageW, imageH);
//            ////fgdfgdfgd
////            _imageH = imageH;
//            //            _cellHeight += Margin/2 + _imageFrame.size.height;
//            _cellHeight += Margin/2 + imageH;
        }        
        NSString *string = self.detailModel.text;
        CGSize maxSize = CGSizeMake(kScreenWidth - Margin * 2, MAXFLOAT);
        CGFloat textH = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
//        CGFloat textY = CGRectGetMaxY(self.imageFrame) + Margin;
//        self.textFrame = CGRectMake(Margin, textY, maxSize.width, textH);
//        //返回 text 的高度。 给外界使用
//        _textH = textH;//
    /*
        if (![self.text isEqualToString:@""]) {
            _cellHeight += Margin/2 + textH + Margin;
            //            WKLog(@"celllll:%f", _cellHeight);
        }else{
            //            _cellHeight += Margin/2;
        }
//    }
     */
    
    return imageH + textH + 60;
}


- (void)awakeFromNib {
    
//    self.imageC.layer.cornerRadius = 6;
//    self.imageC.layer.masksToBounds = YES;
//    
    // Initialization code
}


//- (void)layoutSubviews{
//    WKLog(@"layoutSubviews");
//    [super layoutSubviews];
//    
//    _imageV.height       = self.detailModel.imageH;
//    _contentLabel.height = self.detailModel.textH;
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
