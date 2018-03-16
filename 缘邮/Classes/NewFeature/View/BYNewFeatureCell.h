//
//  BYNewFeatureCell.h
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYNewFeatureCell : UICollectionViewCell

//新特性要显示的图片
@property(nonatomic, strong) UIImage *image;

//判断是否是最后一页
-(void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;


@end
