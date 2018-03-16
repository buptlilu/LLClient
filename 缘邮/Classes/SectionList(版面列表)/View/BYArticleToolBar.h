//
//  BYArticleToolBar.h
//  缘邮
//
//  Created by LiLu on 16/2/23.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYArticleToolBar;

@protocol BYArticleToolBarDelegate <NSObject>

-(void)articleToolBar:(BYArticleToolBar *)toolBar didClickButton:(NSInteger)index;

@end

@interface BYArticleToolBar : UIView

@property (nonatomic, weak) id<BYArticleToolBarDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *btns;

@property (nonatomic, strong) UIPickerView *pageView;

@end
