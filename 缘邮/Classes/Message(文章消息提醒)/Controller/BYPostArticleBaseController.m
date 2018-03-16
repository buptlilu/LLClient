//
//  BYPostArticleBaseController.m
//  缘邮
//
//  Created by LiLu on 16/2/29.
//  Copyright © 2016年 lilu. All rights reserved.
//

#import "BYPostArticleBaseController.h"
#import "BYSimpleTextParser.h"
#import "BYMessageTool.h"
#import "BYTextTool.h"
#import "BYPostArticleParam.h"
#import "BYArticleTool.h"
#import "BYArticle.h"
#import "BYReplyMsgParam.h"

#import "YYTextView.h"
#import "WUDemoKeyboardBuilder.h"
#import "UIBarButtonItem+Item.h"
#import "MBProgressHUD+MJ.h"

@interface BYPostArticleBaseController ()<YYTextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *inputMsgTitleTextView;
@property (weak, nonatomic) IBOutlet YYTextView *inputMsgContentTextView;
/**
 *  输入框表情
 */
@property (nonatomic, strong) UIToolbar *keyboardToolbar;

- (IBAction)sendClick:(UIBarButtonItem *)sender;

@end

@implementation BYPostArticleBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem.dk_tintColorPicker = DKColor_BACKGROUND_NAVBAR_TINT;
    
    //对正文输入框进行一些设置
    [self setUpContentTextView];
    
    //把参数里的内容展示到界面上来
    if (self.replyParam) {
        [self showParamContent];
    }
    
    //设置输入框
    [self setUpToolBar];
    
    //让回复内容输入框成为第一响应者,或者焦点让用户输入
    [self.inputMsgContentTextView becomeFirstResponder];
}

- (void)showParamContent{
    self.inputMsgTitleTextView.text = self.replyParam.title;
    self.inputMsgContentTextView.text = self.replyParam.content;
    
    //把光标位置移到最开始的地方
    NSRange range = NSMakeRange(0, 0);
    self.inputMsgContentTextView.selectedRange = range;
}

- (void)setUpContentTextView{
    //给输入框添加文本解析器解析表情
    self.inputMsgContentTextView.textParser = (id)[[BYSimpleTextParser alloc] init];
    self.inputMsgContentTextView.font = BYMailContentFont;
}



#pragma mark 发送
- (IBAction)sendClick:(UIBarButtonItem *)sender {
    if (self.replyParam) {
        [self replyArticle];
    }
    else if (self.postParam){
        [self postArticle];
    }
}

- (void)postArticle{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.postParam.title = self.inputMsgTitleTextView.text;
    self.postParam.content = [NSString stringWithFormat:@"%@\n[url=%@]来自 缘邮[/url]", self.inputMsgContentTextView.text, @"https://itunes.apple.com/cn/app/yuan-you/id1090911909?l=en&mt=8"];
    
    [BYArticleTool postArticleWithArticleParam:self.postParam whenSuccess:^(BYArticle *article) {
        if (article != nil) {
            //发送成功
            [MBProgressHUD showSuccess:@"发帖成功"];
            //发送成功回到上一个界面
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"发帖失败"];
        }
        
    } whenfailure:^(NSError *error) {
        //发送失败
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"发帖失败"];
        BYLog(@"%@", error);
    }];

}

- (void)replyArticle{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.replyParam.content = [NSString stringWithFormat:@"%@\n[url=%@]来自 缘邮[/url]", self.inputMsgContentTextView.text, @"https://itunes.apple.com/cn/app/yuan-you/id1090911909?l=en&mt=8"];
    
    [BYArticleTool replyMsgWithArticleParam:self.replyParam whenSuccess:^(BYArticle *article) {
        if (article != nil) {
            //发送成功
            [MBProgressHUD showSuccess:@"回复成功"];
            //发送成功回到上一个界面
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"回复失败"];
        }
        
    } whenfailure:^(NSError *error) {
        //发送失败
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"回复失败"];
        BYLog(@"%@", error);
    }];
}


/**
 *  设置输入框
 */
- (void)setUpToolBar{
    //设置代理,拖动的时候,键盘消失
    self.inputMsgContentTextView.delegate = self;
    
    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    self.keyboardToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *emotionBarItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] highImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] target:self action:@selector(switchToEmotionKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *spaceBarItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    
    [self.keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, emotionBarItem, spaceBarItem1, nil]];
    
    self.inputMsgContentTextView.inputAccessoryView = self.keyboardToolbar;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(switchToDefaultKeyboard)
               name:WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification
             object:nil];
    
    UIPanGestureRecognizer* recognizer;
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewWillBeginDragging:)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma mark 表情框出现和消失的事件
//让表情框消失
- (void)switchToDefaultKeyboard {
    [self.inputMsgContentTextView resignFirstResponder];
    
    [self.inputMsgContentTextView switchToDefaultKeyboard];
    self.inputMsgContentTextView.inputAccessoryView = self.keyboardToolbar;
    
    [self.inputMsgContentTextView becomeFirstResponder];
}


//让输入表情框出现
- (void)switchToEmotionKeyboard {
    [self.inputMsgContentTextView resignFirstResponder];
    
    [self.inputMsgContentTextView switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
    self.inputMsgContentTextView.inputAccessoryView = nil;
    
    [self.inputMsgContentTextView becomeFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.inputMsgContentTextView resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
