//
//  BYPostArticleBaseController.h
//  缘邮
//
//  Created by LiLu on 16/2/29.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYTextView, BYReplyMsgParam, BYPostArticleParam;
@interface BYPostArticleBaseController : UIViewController
@property (nonatomic, strong) BYReplyMsgParam *replyParam;
@property (nonatomic, strong) BYPostArticleParam *postParam;
@end
