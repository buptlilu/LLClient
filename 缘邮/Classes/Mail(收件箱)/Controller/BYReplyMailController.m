//
//  BYReplyMailController.m
//  缘邮
//
//  Created by LiLu on 16/2/20.
//  Copyright (c) 2016年 lilu. All rights reserved.
//

#import "BYReplyMailController.h"
#import "BYTextTool.h"
#import "BYMailTool.h"
#import "BYReplyMailParam.h"
#import "BYSimpleTextParser.h"

#import "YYTextView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "WUDemoKeyboardBuilder.h"
#import "UIBarButtonItem+Item.h"

@interface BYReplyMailController ()<YYTextViewDelegate>

/**
 *  回复邮件
 *
 *  @param sender 按钮
 */
- (IBAction)replyMail:(UIBarButtonItem *)sender;

/**
 *  输入用户ID
 */
@property (weak, nonatomic) IBOutlet UITextField *inputUserIdTextField;

/**
 *  邮件标题
 */
@property (weak, nonatomic) IBOutlet UITextField *inputMailTitleTextField;

/**
 *  输入邮件正文
 */
@property (weak, nonatomic) IBOutlet YYTextView *inputMailContentTextView;

/**
 *  输入框表情
 */
@property (nonatomic, strong) UIToolbar *keyboardToolbar;

@end

@implementation BYReplyMailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //对正文输入框进行一些设置
    [self setUpContentTextView];
    
    //把参数里的内容展示到界面上来
    [self showParamContent];
    
    //设置输入框
    [self setUpToolBar];
    
    //让回复内容输入框成为第一响应者,或者焦点让用户输入
    [self.inputMailContentTextView becomeFirstResponder];
}

- (void)setUpContentTextView{
    //给输入框添加文本解析器解析表情
    self.inputMailContentTextView.textParser = (id)[[BYSimpleTextParser alloc] init];
    self.inputMailContentTextView.font = BYMailContentFont;
}

- (void)showParamContent{
    self.inputUserIdTextField.text = self.param.BYid;
    self.inputMailTitleTextField.text = self.param.title;
    self.inputMailContentTextView.text = self.param.content;
    
    //把光标位置移到最开始的地方
    NSRange range = NSMakeRange(0, 0);
    self.inputMailContentTextView.selectedRange = range;
}

/**
 *  设置输入框
 */
- (void)setUpToolBar{
    //设置代理,拖动的时候,键盘消失
    self.inputMailContentTextView.delegate = self;
    
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
    
    self.inputMailContentTextView.inputAccessoryView = self.keyboardToolbar;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(switchToDefaultKeyboard)
               name:WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification
             object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //
    //    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //    if (version >= 5.0) {
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //    }
    
    UIPanGestureRecognizer* recognizer;
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewWillBeginDragging:)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma mark 表情框出现和消失的事件
//让表情框消失
- (void)switchToDefaultKeyboard {
    [self.inputMailContentTextView resignFirstResponder];
    
    [self.inputMailContentTextView switchToDefaultKeyboard];
    self.inputMailContentTextView.inputAccessoryView = self.keyboardToolbar;
    
    [self.inputMailContentTextView becomeFirstResponder];
}


//让输入表情框出现
- (void)switchToEmotionKeyboard {
    [self.inputMailContentTextView resignFirstResponder];
    
    [self.inputMailContentTextView switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
    self.inputMailContentTextView.inputAccessoryView = nil;
    
    [self.inputMailContentTextView becomeFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.inputUserIdTextField resignFirstResponder];
    [self.inputMailTitleTextField resignFirstResponder];
    [self.inputMailContentTextView resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)replyMail:(UIBarButtonItem *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    BYLog(@"正文:%@====%@", self.inputMailContentTextView.attributedText.string, self.inputMailContentTextView.text);
    
    self.param.title = self.inputMailTitleTextField.text;
    self.param.content = self.inputMailContentTextView.text;
    
    [BYMailTool replyMailWithParam:self.param whenSuccess:^(BYMail *replyMail) {
        if (replyMail != nil) {
            //发送成功
            [MBProgressHUD showSuccess:@"回复成功"];
            //发送成功回到上一个界面
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"回复失败"];
        }
    } whenFailure:^(NSError *error) {
        //发送失败
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"回复失败"];
        BYLog(@"%@", error);
    }];
}

@end
