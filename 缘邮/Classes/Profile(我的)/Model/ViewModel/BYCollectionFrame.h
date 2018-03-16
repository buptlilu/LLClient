//
//  BYCollectionFrame.h
//  缘邮
//
//  Created by LiLu on 16/2/27.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYCollection;
@interface BYCollectionFrame : NSObject

@property (nonatomic, strong) BYCollection *collection;

@property (nonatomic, assign) CGRect titleLabelFrame;

@property (nonatomic, assign) CGRect boardLabelFrame;

@property (nonatomic, assign) CGRect collectTimeLabelFrame;

@property (nonatomic, assign) CGRect spaceViewFrame;

@property (nonatomic, assign) CGRect arrowViewFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@end
