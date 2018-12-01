//
//  RegisterViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/22.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewController+XLBubbleTransition.h"
#import "RegisterNextViewController.h"
@interface RegisterViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIButton *exitButton;
@property(nonatomic,strong)UIImageView *logoImageView;
@property(nonatomic,strong)UIView *inputView;
@property(nonatomic,strong)UITextField *accountTextField;
@property(nonatomic,strong)UITextField *passwordTextField;
@property(nonatomic,strong)UITextField *confirmPasswordTextField;
@property(nonatomic,strong)UITextField *nickNameTextField;

@property(nonatomic,strong)UIButton *nextButton;

@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UIButton *browseButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [SDUtils hexStringToColor:@"f5f5f5"];
    
    [self.view addSubview:self.exitButton];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.bottomView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
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
        [_exitButton addTarget:self action:@selector(popLoginViewController) forControlEvents:UIControlEventTouchUpInside];
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
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_logoImageView.frame)+20, KmainWidth-40, 181.5)];
        _inputView.backgroundColor = [UIColor lightGrayColor];
        _inputView.layer.cornerRadius = 5.0f;
        _inputView.layer.masksToBounds = YES;
        _inputView.layer.borderWidth = 0.5f;
        _inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_inputView addSubview:self.accountTextField];
        [_inputView addSubview:self.passwordTextField];
        [_inputView addSubview:self.confirmPasswordTextField];
        [_inputView addSubview:self.nickNameTextField];

    }
    
    return _inputView;
}

-(UITextField *)accountTextField{
    
    if (_accountTextField == nil) {
        _accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KmainWidth-40, 45)];
        _accountTextField.backgroundColor = [UIColor whiteColor];
        _accountTextField.placeholder = @"注册账号";
        _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountTextField.delegate = self;
        _accountTextField.font = [UIFont systemFontOfSize:15];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"账号图标"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 45, 45);
        _accountTextField.leftViewMode = UITextFieldViewModeAlways;
        _accountTextField.leftView = leftView;
        [_accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_accountTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
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
        _passwordTextField.font = [UIFont systemFontOfSize:15];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"密码图标"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 45, 45);
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextField.leftView = leftView;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return _passwordTextField;
}

-(UITextField *)confirmPasswordTextField{
    
    if (_confirmPasswordTextField == nil) {
        _confirmPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 91, KmainWidth-40, 45)];
        _confirmPasswordTextField.backgroundColor = [UIColor whiteColor];
        _confirmPasswordTextField.placeholder = @"确认密码";
        _confirmPasswordTextField.secureTextEntry = YES;
        _confirmPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _confirmPasswordTextField.delegate = self;
        _confirmPasswordTextField.font = [UIFont systemFontOfSize:15];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"密码图标"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 45, 45);
        _confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        _confirmPasswordTextField.leftView = leftView;
        [_confirmPasswordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_confirmPasswordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return _confirmPasswordTextField;
}

-(UITextField *)nickNameTextField{
    
    if (_nickNameTextField == nil) {
        _nickNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 136.5, KmainWidth-40, 45)];
        _nickNameTextField.backgroundColor = [UIColor whiteColor];
        _nickNameTextField.placeholder = @"你的昵称";
        _nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nickNameTextField.delegate = self;
        _nickNameTextField.font = [UIFont systemFontOfSize:15];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"用户昵称"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 45, 45);
        _nickNameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nickNameTextField.leftView = leftView;
        [_nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_nickNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return _nickNameTextField;
}


-(UIButton *)nextButton{
    
    if (_nextButton == nil) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(20, CGRectGetMaxY(_inputView.frame)+20, KmainWidth-40, 45);
        _nextButton.layer.cornerRadius = 5.0f;
        _nextButton.layer.masksToBounds = YES;
        _nextButton.userInteractionEnabled = NO;
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setBackgroundColor:[SDUtils  hexStringToColor:@"8ecc83"]];
        [_nextButton addTarget:self action:@selector(registerAciton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

-(UIView *)bottomView{
    
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KmainHeight-40, KmainWidth, 30)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(KmainWidth/2.0, 5, 1, 20)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_bottomView addSubview:lineView];
        [_bottomView addSubview:self.loginButton];
        [_bottomView addSubview:self.browseButton];
    }
    return _bottomView;
}

-(UIButton *)loginButton{
    
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(0, 0, KmainWidth/2-10, 30);
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_loginButton setTitleColor:[SDUtils hexStringToColor:KmainColor] forState:UIControlStateNormal];
        [_loginButton setTitle:@"已有账号登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(popLoginViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIButton *)browseButton{
    
    if (_browseButton == nil) {
        _browseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _browseButton.frame = CGRectMake(KmainWidth/2+10, 0, KmainWidth/2-10, 30);
        _browseButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _browseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_browseButton setTitleColor:[SDUtils hexStringToColor:@"c0c0c0"] forState:UIControlStateNormal];
        [_browseButton setTitle:@"随便看看" forState:UIControlStateNormal];
        [_browseButton addTarget:self action:@selector(dismissMainViewController) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _browseButton;
}


#pragma mark --- 操作事件 ---
-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if (_passwordTextField.text.length >0 && _accountTextField.text.length>0 && _confirmPasswordTextField.text.length>0 && _nickNameTextField.text.length>0) {
        [_nextButton setBackgroundColor:[SDUtils  hexStringToColor:@"349a23"]];
        _nextButton.userInteractionEnabled = YES;
    }else{
        [_nextButton setBackgroundColor:[SDUtils  hexStringToColor:@"8ecc83"]];
        _nextButton.userInteractionEnabled = NO;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
    [_nickNameTextField resignFirstResponder];

}


-(void)registerAciton{
    
    if (_accountTextField.text == nil || [_accountTextField.text isEqualToString:@""]) {
        NSLog(@"账号不合格");
        return;
    }
    
    if (![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
        NSLog(@"两次输入密码不一致");
        return;
    }
    
    if (_nickNameTextField.text == nil || [_nickNameTextField.text isEqualToString:@""]) {
        NSLog(@"昵称不能为空");
        return;
    }
    
    RegisterNextViewController *nextVC = [[RegisterNextViewController alloc]init];
    nextVC.account = _accountTextField.text;
    nextVC.password = _passwordTextField.text;
    nextVC.nickname = _nickNameTextField.text;
    
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)dismissMainViewController{

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)popLoginViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ---- 键盘事件 ----
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGFloat rects = 0;
    if ([_nickNameTextField isFirstResponder] || [_confirmPasswordTextField isFirstResponder]) {
        rects = self.view.frame.size.height - (_nextButton.frame.origin.y + _nextButton.frame.size.height+height);
    }
    
    if ([_accountTextField isFirstResponder] || [_passwordTextField isFirstResponder]) {
        rects = self.view.frame.size.height - (_passwordTextField.frame.origin.y + _passwordTextField.frame.size.height+height);
    }
    
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



@end
