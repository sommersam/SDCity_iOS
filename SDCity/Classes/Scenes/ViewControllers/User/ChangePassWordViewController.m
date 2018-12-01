//
//  ChangePassWordViewController.m
//  SDCity
//
//  Created by wangweidong on 2018/1/3.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "HttpManager.h"
#import "UserManager.h"
@interface ChangePassWordViewController ()

@property(nonatomic,strong)UITextField *oldPassWordTextField;
@property(nonatomic,strong)UITextField *nowPassWordTextField;
@property(nonatomic,strong)UITextField *confirmTextField;
@property(nonatomic,strong)UIButton *changeButton;

@end

@implementation ChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavgationBar];
    [self.view addSubview:self.oldPassWordTextField];
    [self.view addSubview:self.nowPassWordTextField];
    [self.view addSubview:self.confirmTextField];
    [self.view addSubview:self.changeButton];

    self.view.backgroundColor = [SDUtils hexStringToColor:@"fafafa"];
    
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

-(void)loadNavgationBar{
    
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, KmainWidth-64*2, 44);
    titleButton.titleLabel.font = KBoldFont(20);
    [titleButton setTitle:@" 修改密码" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"Puzzle"] forState:UIControlStateNormal];
    titleButton.userInteractionEnabled = NO;
    self.navigationItem.titleView = titleButton;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:KBoldFont(20),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAciton)];
    self.navigationItem.leftBarButtonItem.tintColor = KmyColor(240, 240, 240);
    
}

-(void)popViewControllerAciton{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Senty" size:32],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 懒加载 ----

-(UITextField *)oldPassWordTextField{
    
    if (_oldPassWordTextField == nil) {
        _oldPassWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(KmainWidth*0.1, StatusHeight+44+30, KmainWidth*0.8, 45)];
        _oldPassWordTextField.secureTextEntry = YES;
        _oldPassWordTextField.placeholder = @"旧密码";
        _oldPassWordTextField.backgroundColor = [UIColor whiteColor];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"密码图标"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 40, 40);
        _oldPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
        _oldPassWordTextField.leftView = leftView;
        _oldPassWordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _oldPassWordTextField.layer.borderWidth = 0.25f;
    }
    
    return _oldPassWordTextField;
}

-(UITextField *)nowPassWordTextField{
    
    if (_nowPassWordTextField == nil) {
        _nowPassWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(KmainWidth*0.1, CGRectGetMaxY(_oldPassWordTextField.frame), KmainWidth*0.8, 45)];
        _nowPassWordTextField.secureTextEntry = YES;
        _nowPassWordTextField.placeholder = @"新密码";
        _nowPassWordTextField.backgroundColor = [UIColor whiteColor];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"密码图标"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.tintColor = [SDUtils hexStringToColor:@"E45948"];
        leftView.frame = CGRectMake(0, 0, 40, 40);
        _nowPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
        _nowPassWordTextField.leftView = leftView;
        _nowPassWordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _nowPassWordTextField.layer.borderWidth = 0.25f;
    }
    
    return _nowPassWordTextField;
}

-(UITextField *)confirmTextField{
    
    if (_confirmTextField == nil) {
        _confirmTextField = [[UITextField alloc]initWithFrame:CGRectMake(KmainWidth*0.1, CGRectGetMaxY(_nowPassWordTextField.frame), KmainWidth*0.8, 45)];
        _confirmTextField.secureTextEntry = YES;
        _confirmTextField.placeholder = @"确认密码";
        _confirmTextField.backgroundColor = [UIColor whiteColor];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"密码图标"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        leftView.tintColor = [SDUtils hexStringToColor:KmainColor];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 40, 40);
        _confirmTextField.leftViewMode = UITextFieldViewModeAlways;
        _confirmTextField.leftView = leftView;
        _confirmTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _confirmTextField.layer.borderWidth = 0.25f;
    }
    
    return _confirmTextField;
}


-(UIButton *)changeButton{
    
    if (_changeButton == nil) {
        _changeButton = [[UIButton alloc] initWithFrame:CGRectMake(KmainWidth*0.1, CGRectGetMaxY(_confirmTextField.frame)+20, KmainWidth*0.8, 45)];
        _changeButton.backgroundColor = [SDUtils hexStringToColor:KmainColor];
        _changeButton.titleLabel.font = KBoldFont(18);
        _changeButton.layer.cornerRadius = 5.0f;
        _changeButton.layer.masksToBounds = YES;
        [_changeButton setTitle:@"修改密码" forState:UIControlStateNormal];
        [_changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeButton  addTarget:self action:@selector(changePassWordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changeButton;
}

#pragma mark ---- 修改密码 ----

-(void)changePassWordAction{
    
    [self.view endEditing:YES];
    
    if ([_oldPassWordTextField.text isEqualToString:@""] || [_nowPassWordTextField.text isEqualToString:@""] || [_confirmTextField.text isEqualToString:@""]||_oldPassWordTextField.text == nil || _nowPassWordTextField.text == nil || _confirmTextField.text == nil ) {
        [SVProgressHUD showErrorWithStatus:@"请填写完信息"];
        [SVProgressHUD dismissWithDelay:0.8];
        return;
    }
    
    if (![_nowPassWordTextField.text isEqualToString:_confirmTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"新密码和确认密码必须一致"];
        [SVProgressHUD dismissWithDelay:0.8];
        return;
    }
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改确认" message:@"确认修改密码?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认修改" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD showWithStatus:@"修改中.."];
        [HttpManager changeUserPassWordActionWithUserId:[UserManager standardUserManager].userId oldpassword:_oldPassWordTextField.text newpassword:_nowPassWordTextField.text andHandle:^(NSString *error, NSDictionary *result) {
            
            if (error == nil) {
                [[NSUserDefaults standardUserDefaults] setObject:_nowPassWordTextField.text forKey:UserPassword];
                [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
                [SVProgressHUD dismissWithDelay:0.8];
            }else{
                [SVProgressHUD showErrorWithStatus:@"操作失败"];
                [SVProgressHUD dismissWithDelay:0.8];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark ---- 键盘事件 ----
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    CGFloat rects = self.view.frame.size.height - (_confirmTextField.frame.origin.y + _confirmTextField.frame.size.height+height);
    
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
