//
//  BYOAuthController.m
//  缘邮
//
//  Created by LiLu on 15/11/26.
//  Copyright (c) 2015年 lilu. All rights reserved.
//

#import "BYOAuthController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "BYRootTool.h"
#import "BYAccount.h"
#import "BYAccountTool.h"
#import "LoginInputView.h"
#import "BYHttpTool.h"

/*
 向这个url发请求即可
 client_id	dcaea32813eca7e0a547728b73ab060a
 response_type	code
 redirect_uri	http://bbs.byr.cn/oauth2/callback
 state	35f7879b051b0bcb77a015977f5aeeeb
 scope	/
 username	chujunhe1234
 password	lilu2010
 */
#define BYOAuthURL @"https://bbs.byr.cn/oauth2/official"

@interface BYOAuthController ()<UIWebViewDelegate, UITextFieldDelegate>
@property (nonatomic, weak) LoginInputView *userNameView;
@property (nonatomic, weak) LoginInputView *passwordView;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, assign) BOOL canLogin;
@end

@implementation BYOAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //展示登录的网页
//    [self setUpWebView];
    
    [self setUpLoginViews];
}

#pragma mark - functions
- (void)setUpWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    webView.delegate = self;
    self.webView = webView;
    [self loadLoginView];
}

- (void)loadLoginView {
    //加载网页
    NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=%@&state=%@&appleid=%@&bundleid=%@", BYAuthorizeBaseUrl, BYClient_id, BYRedirect_uri, BYResponse_type, BYState, BYAppleid, BYBundleid];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    BYLog(@"oAuthUrl:%@", urlStr);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //加载请求
    [self.webView loadRequest:request];
}

- (void)setUpLoginViews {
    UIView *loginView = [[UIView alloc] initWithFrame:self.view.bounds];
    loginView.dk_backgroundColorPicker = DKColor_BACKGROUND;
    [self.view addSubview:loginView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-128"]];
    [loginView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.equalTo(loginView);
        make.top.equalTo(loginView).with.offset(40);
    }];
    
    UILabel *label = [UILabel labelWith:[UIFont boldSystemFontOfSize:20] textColor:DKColorWithColors([UIColor orangeColor], [UIColor orangeColor]) textAlignment:NSTextAlignmentCenter];
    label.text = @"请先登录";
    [loginView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width, 24));
        make.centerX.equalTo(loginView);
        make.top.mas_equalTo(imageView.mas_bottom).with.offset(20);
    }];
    
    //用户名
    CGFloat userNameY = 200;
    LoginInputView *userNameView = [[LoginInputView alloc] init];
    userNameView.x = 0;
    userNameView.y = userNameY;
    [loginView addSubview:userNameView];
    self.userNameView = userNameView;
    userNameView.inputView.placeholder = @"论坛ID";
    userNameView.inputView.keyboardType = UIKeyboardTypeURL;
    [userNameView.inputView setValue:[XUtil isDay] ? [XUtil hexToRGB:@"CCCCCC"] : [XUtil hexToRGB:@"3B3E40"] forKeyPath:@"_placeholderLabel.textColor"];
    userNameView.inputView.delegate = self;
    [userNameView.inputView addTarget:self action:@selector(userNameValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //密码
    LoginInputView *passwordView = [[LoginInputView alloc] init];
    passwordView.x = 0;
    passwordView.y = MaxY(userNameView);
    [loginView addSubview:passwordView];
    self.passwordView = passwordView;
    passwordView.inputView.delegate = self;
    passwordView.inputView.placeholder = @"论坛密码";
    passwordView.inputView.secureTextEntry = YES;
    passwordView.inputView.clearsOnBeginEditing = YES;
    passwordView.inputView.returnKeyType = UIReturnKeyDone;
    [passwordView.inputView setValue:[XUtil isDay] ? [XUtil hexToRGB:@"CCCCCC"] : [XUtil hexToRGB:@"3B3E40"] forKeyPath:@"_placeholderLabel.textColor"];
    [passwordView.inputView addTarget:self action:@selector(passwordValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.clipsToBounds = YES;
    [loginBtn setBackgroundImage:[XUtil createImageWithColor: [UIColor orangeColor]] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [loginBtn addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    CGFloat btnX = Main_Screen_Width * 0.0625;
    CGFloat btnY = MaxY(passwordView) + 32;
    CGFloat btnW = Main_Screen_Width - 2 * btnX;
    CGFloat btnH = 48;
    loginBtn.layer.cornerRadius = btnH * 0.5;
    loginBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [self checkLoginBtnStatus];
}

- (void)toLogin:(UIButton *)btn {
    [self.userNameView.inputView resignFirstResponder];
    [self.passwordView.inputView resignFirstResponder];
    
    if ([self.userNameView.inputView.text length] == 0) {
        [MBProgressHUD showCustomMessage:@"用户名不能为空" toView:self.view];
        return;
    }
    
    if ([self.passwordView.inputView.text length] == 0) {
        [MBProgressHUD showCustomMessage:@"密码不能为空" toView:self.view];
        return;
    }
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('Username').value = '%@'", self.userNameView.inputView.text]];
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('Password').value = '%@'", self.passwordView.inputView.text]];
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('login_button').click()"];
    
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    param[@"appkey"] = @"8b0d6c0b2ff8ef15c35c896435f0f337";
    param[@"response_type"] = BYResponse_type;
    param[@"redirect_uri"] = BYRedirect_uri;
    param[@"state"] = BYState;
    param[@"scope"] = @"/";
    param[@"source"] = @"1503026743-1";
    param[@"username"] = [[self.userNameView.inputView.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    param[@"password"] = [[self.passwordView.inputView.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:BYOAuthURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BYLog(@"res:%@", responseObject);
        [BYAccountTool accessTokenWithDict:responseObject whenSuccess:^{
            //进入主页或者新特性，选择窗口的根控制器
            [MBProgressHUD showCustomMessage:@"登录成功" toView:self.view];
            [BYRootTool chooseRootViewController:BYKeyWindow];
        } whenFailue:^(NSError *error) {
            [MBProgressHUD showCustomMessage:@"网络问题，请重新登录" toView:self.view];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showCustomMessage:@"网络问题，请检查网络" toView:self.view];
        return;
        NSString *urlStr = operation.response.URL.absoluteString;
        if (urlStr == nil) {
            [MBProgressHUD showCustomMessage:@"网络问题，请检查网络" toView:self.view];
        }else {
            NSRange range = [urlStr rangeOfString:@"code="];
            if (range.length > 0) { //有code=
                //code=f519997d23ff5af11e29cccedc025bbf 32位
                NSRange codeRange = NSMakeRange(range.location + range.length, 32);
                NSString *code = [urlStr substringWithRange:codeRange];
                BYLog(@"%@", code);
                
                //换取accessToken
                [self accessTokenWithCode:code];
            }else {
                [MBProgressHUD showCustomMessage:@"登录失败,用户名或密码错误" toView:self.view];
            }
        }
    }];
    /*
     BYClient_id, BYRedirect_uri, BYResponse_type, BYState, BYAppleid, BYBundleid
     client_id	dcaea32813eca7e0a547728b73ab060a
     response_type	code
     redirect_uri	http://bbs.byr.cn/oauth2/callback
     state	35f7879b051b0bcb77a015977f5aeeeb
     scope	/
     username	chujunhe1234
     password	lilu2010
     */
}

- (void)userNameValueChanged:(UITextField *)sender {
    [self checkLoginBtnStatus];
}

- (void)passwordValueChanged:(UITextField *)sender {
    [self checkLoginBtnStatus];
}

- (void)checkLoginBtnStatus {
    if (self.userNameView.inputView.text.length && self.passwordView.inputView.text.length) {
        [self.loginBtn setTitleColor:[XUtil hexToRGB:@"FFFFFF" setAlpha:1] forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = YES;
    }else {
        [self.loginBtn setTitleColor:[XUtil hexToRGB:@"FFFFFF" setAlpha:0.5] forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.superview isKindOfClass:[LoginInputView class]]) {
        LoginInputView *view = (LoginInputView *)textField.superview;
        view.spaceView.dk_backgroundColorPicker = DKColorWithColors([UIColor orangeColor], [UIColor orangeColor]);
    }
    
    [self checkLoginBtnStatus];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.superview isKindOfClass:[LoginInputView class]]) {
        LoginInputView *view = (LoginInputView *)textField.superview;
        view.spaceView.dk_backgroundColorPicker = view.normalPicker;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (1 == range.length) {//按下回格键
        return YES;
    }
    
    if ([string isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [textField resignFirstResponder];
        return NO;
    }else {
        if ([textField.text length] < 140) {//判断字符个数
            return YES;
        }
    }
    return NO;
}

#pragma mark -UIWebView代理
//webView加载完成的时候调用
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //webView缩放
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.75"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//加载失败之后也要移除，因为授权之后没有返回界面就意味着是加载失败了
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showCustomMessage:@"网络问题，请重新登录" toView:self.view];
}

//用来拦截webView请求
//当webView需要加载一个请求的时候，就会调用这个方法，询问下是否请求
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
    BYLog(@"%@", urlStr);
    
    //获取code(RequestToken)
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length > 0) { //有code=
        
        //code=f519997d23ff5af11e29cccedc025bbf 32位
        NSRange codeRange = NSMakeRange(range.location + range.length, 32);
        NSString *code = [urlStr substringWithRange:codeRange];
        BYLog(@"%@", code);
        
        //换取accessToken
        [self accessTokenWithCode:code];
        
        //不会去加载回调界面
        return NO;
    }
    
    return YES;
}

#pragma mark - 换取accessToken
- (void)accessTokenWithCode:(NSString *)code{
    [BYAccountTool accessTokenWithCode:code whenSuccess:^{
        //进入主页或者新特性，选择窗口的根控制器
        [MBProgressHUD showCustomMessage:@"登录成功" toView:self.view];
        [BYRootTool chooseRootViewController:BYKeyWindow];
    } whenFailue:^(NSError *error) {
        BYLog(@"%@", error);
        [MBProgressHUD showCustomMessage:@"网络问题，请重新登录" toView:self.view];
    }];
}
@end
