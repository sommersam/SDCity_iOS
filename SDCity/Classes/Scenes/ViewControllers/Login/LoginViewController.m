
//
//  LoginViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/22.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "HttpManager.h"
#import "XLBubbleTransition.h"
#import "SVProgressHUD.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIButton *exitButton;
@property(nonatomic,strong)UIImageView *logoImageView;
@property(nonatomic,strong)UIView *inputView;
@property(nonatomic,strong)UITextField *accountTextField;
@property(nonatomic,strong)UITextField *passwordTextField;
@property(nonatomic,strong)UIButton *loginButton;

@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *registerButton;
@property(nonatomic,strong)UIButton *browseButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.exitButton];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.bottomView];

    self.view.backgroundColor = [SDUtils hexStringToColor:@"fafafa"];
    self.xl_pushTranstion = [XLBubbleTransition transitionWithAnchorRect:CGRectMake(KmainWidth/2.0, KmainHeight/2.0,30,30)];
    self.xl_popTranstion = [XLBubbleTransition transitionWithAnchorRect:CGRectMake(KmainWidth/2.0, KmainHeight/2.0,30,30)];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}



#pragma mark ---- 懒加载 ----
-(UIButton *)exitButton{
    
    if (_exitButton == nil) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitButton.frame = CGRectMake(10, StatusHeight+10, 30, 30);
        [_exitButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(dismissLoginViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}

-(UIImageView *)logoImageView{
    
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登录页logo"]];
        _logoImageView.contentMode = UIViewContentModeCenter;
        _logoImageView.frame = CGRectMake(KmainWidth/2-100,CGRectGetMaxY(_exitButton.frame) +10, 200, 114);
    }
    
    return _logoImageView;
}

-(UIView *)inputView{
    
    if (_inputView == nil) {
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_logoImageView.frame)+20, KmainWidth-40, 90.5)];
        _inputView.backgroundColor = [UIColor lightGrayColor];
        _inputView.layer.cornerRadius = 5.0f;
        _inputView.layer.masksToBounds = YES;
        _inputView.layer.borderWidth = 0.5f;
        _inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_inputView addSubview:self.accountTextField];
        [_inputView addSubview:self.passwordTextField];
    }
    
    return _inputView;
}

-(UITextField *)accountTextField{
    
    if (_accountTextField == nil) {
        _accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KmainWidth-40, 45)];
        _accountTextField.backgroundColor = [UIColor whiteColor];
        _accountTextField.placeholder = @"账号";
        _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountTextField.delegate = self;
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"账号图标"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 45, 45);
        _accountTextField.leftViewMode = UITextFieldViewModeAlways;
        _accountTextField.leftView = leftView;
        [_accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_accountTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:UserAccount] != nil) {
            _accountTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:UserAccount];
        }
    }
    return _accountTextField;
}

-(UITextField *)passwordTextField{
    
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 45.5, KmainWidth-40, 45)];
        _passwordTextField.backgroundColor = [UIColor whiteColor];
        _passwordTextField.placeholder = @"密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.delegate = self;
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"密码图标"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 45, 45);
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextField.leftView = leftView;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:UserPassword] != nil) {
            _passwordTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:UserPassword];
        }
    }
    return _passwordTextField;
}

-(UIButton *)loginButton{
    
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(20, CGRectGetMaxY(_inputView.frame)+20, KmainWidth-40, 45);
        _loginButton.layer.cornerRadius = 5.0f;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.userInteractionEnabled = NO;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[SDUtils  hexStringToColor:@"83bbe0"]];
        [_loginButton addTarget:self action:@selector(loginAciton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIView *)bottomView{
    
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KmainHeight-40, KmainWidth, 30)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(KmainWidth/2.0, 5, 1, 20)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_bottomView addSubview:lineView];
        [_bottomView addSubview:self.registerButton];
        [_bottomView addSubview:self.browseButton];
    }
    return _bottomView;
}

-(UIButton *)registerButton{
    
    if (_registerButton == nil) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(0, 0, KmainWidth/2-10, 30);
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_registerButton setTitleColor:[SDUtils hexStringToColor:KmainColor] forState:UIControlStateNormal];
        [_registerButton setTitle:@"新用户注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(presentRegisterViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

-(UIButton *)browseButton{
    
    if (_browseButton == nil) {
        _browseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _browseButton.frame = CGRectMake(KmainWidth/2+10, 0, KmainWidth/2-10, 30);
        _browseButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _browseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_browseButton setTitleColor:[SDUtils hexStringToColor:@"c0c0c0"] forState:UIControlStateNormal];
        [_browseButton setTitle:@"随便看看" forState:UIControlStateNormal];
        [_browseButton addTarget:self action:@selector(dismissLoginViewController) forControlEvents:UIControlEventTouchUpInside];

    }
    return _browseButton;
}


#pragma mark --- 操作事件 ---
-(void)textFieldDidChange :(UITextField *)theTextField{

    if (_passwordTextField.text.length >0 && _accountTextField.text.length>0) {
        [_loginButton setBackgroundColor:[SDUtils  hexStringToColor:@"287fc0"]];
        _loginButton.userInteractionEnabled = YES;
    }else{
        [_loginButton setBackgroundColor:[SDUtils  hexStringToColor:@"83bbe0"]];
        _loginButton.userInteractionEnabled = NO;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

#pragma mark ---- 键盘事件 ----
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    CGFloat rects = self.view.frame.size.height - (_loginButton.frame.origin.y + _loginButton.frame.size.height+height);
    
    if (rects <= 0) {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = rects;
            self.view.frame = frame;
        }];
    }
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    [UIView animateWithDuration:0.1 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
}


#pragma mark ----登录事件----
-(void)loginAciton{
    [SVProgressHUD showWithStatus:@"登录中...."];
    [HttpManager userLoginActionWithAccount:_accountTextField.text password:_passwordTextField.text andHandle:^(NSString *error, NSDictionary *result) {
    
        if ([result[@"code"] intValue] == 200) {
            [self dismissLoginViewController];
            [SVProgressHUD dismissWithDelay:0.1];
        }else if ([result[@"code"] intValue] == 1001){
            [SVProgressHUD showErrorWithStatus:@"用户不存在!"];
        }else if ([result[@"code"] intValue] == -1){
            [SVProgressHUD showErrorWithStatus:@"密码错误!"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"登录失败!"];
        }
        [SVProgressHUD dismissWithDelay:0.8];
    }];
    
}

#pragma mark ----跳转注册事件----
-(void)presentRegisterViewController{
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}


#pragma mark ----返回事件----

-(void)dismissLoginViewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
