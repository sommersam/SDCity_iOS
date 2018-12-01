//
//  RegisterNextViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/27.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "RegisterNextViewController.h"
#import "HttpManager.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface RegisterNextViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>{
    
    BOOL isChooseHeaderImage;
}

@property(nonatomic,strong)UIButton *exitButton;
@property(nonatomic,strong)UIImageView *userHeaderImageView;
@property(nonatomic,strong)UIView *inputView;
@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UITextField *emailTextField;
@property(nonatomic,strong)UITextField *addressTextField;

@property(nonatomic,strong)UIButton *registerButton;

@property(nonatomic,strong)UIImagePickerController *imagePickerController;


@end

@implementation RegisterNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [SDUtils hexStringToColor:@"f5f5f5"];
    isChooseHeaderImage = NO;
    [self.view addSubview:self.exitButton];
    [self.view addSubview:self.userHeaderImageView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.registerButton];
    
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


#pragma mark ---- 懒加载 ----
-(UIButton *)exitButton{
    
    if (_exitButton == nil) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitButton.frame = CGRectMake(10, StatusHeight+10, 30, 30);
        [_exitButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(popRegisterViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}

-(UIImageView *)userHeaderImageView{
    
    if (_userHeaderImageView == nil) {
        _userHeaderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"默认用户头像"]];
        _userHeaderImageView.frame = CGRectMake(KmainWidth/2-50,CGRectGetMaxY(_exitButton.frame) +10, 100, 100);
        _userHeaderImageView.layer.cornerRadius = 50.0f;
        _userHeaderImageView.layer.masksToBounds = YES;
        _userHeaderImageView.layer.borderColor = [SDUtils hexStringToColor:KmainNotSelectColor].CGColor;
        _userHeaderImageView.layer.borderWidth = 3.0f;
        _userHeaderImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseMyHeaderImage)];
        [_userHeaderImageView addGestureRecognizer:tap];
    }
    
    return _userHeaderImageView;
}

-(UIView *)inputView{
    
    if (_inputView == nil) {
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_userHeaderImageView.frame)+20, KmainWidth-40, 136)];
        _inputView.backgroundColor = [UIColor lightGrayColor];
        _inputView.layer.cornerRadius = 5.0f;
        _inputView.layer.masksToBounds = YES;
        _inputView.layer.borderWidth = 0.5f;
        _inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_inputView addSubview:self.phoneTextField];
        [_inputView addSubview:self.emailTextField];
        [_inputView addSubview:self.addressTextField];
    }
    
    return _inputView;
}

-(UITextField *)phoneTextField{
    
    if (_phoneTextField == nil) {
        _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KmainWidth-40, 45)];
        _phoneTextField.backgroundColor = [UIColor whiteColor];
        _phoneTextField.placeholder = @"联系电话 (选填)";
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.delegate = self;
        _phoneTextField.font = [UIFont systemFontOfSize:15];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"手机"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 45, 45);
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.leftView = leftView;
        [_phoneTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return _phoneTextField;
}

-(UITextField *)emailTextField{
    
    if (_emailTextField == nil) {
        _emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 45.5, KmainWidth-40, 45)];
        _emailTextField.backgroundColor = [UIColor whiteColor];
        _emailTextField.placeholder = @"邮箱地址 (选填)";
        _emailTextField.secureTextEntry = YES;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.delegate = self;
        _emailTextField.font = [UIFont systemFontOfSize:15];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"邮箱"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 45, 45);
        _emailTextField.leftViewMode = UITextFieldViewModeAlways;
        _emailTextField.leftView = leftView;
        [_emailTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return _emailTextField;
}

-(UITextField *)addressTextField{
    
    if (_addressTextField == nil) {
        _addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 91, KmainWidth-40, 45)];
        _addressTextField.backgroundColor = [UIColor whiteColor];
        _addressTextField.placeholder = @"联系地址 (选填)";
        _addressTextField.secureTextEntry = YES;
        _addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTextField.delegate = self;
        _addressTextField.font = [UIFont systemFontOfSize:15];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"地址"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 45, 45);
        _addressTextField.leftViewMode = UITextFieldViewModeAlways;
        _addressTextField.leftView = leftView;
        [_addressTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return _addressTextField;
}

-(UIButton *)registerButton{
    
    if (_registerButton == nil) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(20, CGRectGetMaxY(_inputView.frame)+20, KmainWidth-40, 45);
        _registerButton.layer.cornerRadius = 5.0f;
        _registerButton.layer.masksToBounds = YES;
        [_registerButton setTitle:@"完成注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButton setBackgroundColor:[SDUtils  hexStringToColor:@"349a23"]];
        [_registerButton addTarget:self action:@selector(registerAciton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

-(UIImagePickerController *)imagePickerController{
    
    if (_imagePickerController == nil) {
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    
    return _imagePickerController;
}


#pragma mark --- 操作事件 ---

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
}


-(void)registerAciton{
    [SVProgressHUD showWithStatus:@"注册中...."];
    [HttpManager userRegisterActionWithAccount:_account password:_password repassword:_password name:_nickname email:_emailTextField.text address:_addressTextField.text phone:_phoneTextField.text headerimg:isChooseHeaderImage?_userHeaderImageView.image:nil andHandle:^(NSString *error, NSDictionary *result) {
        NSLog(@"%@",result);

        if (error == nil) {
            
            if ([result[@"code"] intValue] == 200) {
                [[NSUserDefaults standardUserDefaults] setObject:_account forKey:UserAccount];
                [[NSUserDefaults standardUserDefaults] setObject:_password forKey:UserPassword];
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                [SVProgressHUD dismissWithDelay:0.8];
                [self popLoginViewController];
            }
            if ([result[@"code"] intValue] == 1008) {
                [SVProgressHUD showErrorWithStatus:@"账号已经存在,请重试"];
                [SVProgressHUD dismissWithDelay:0.8];
                [self popRegisterViewController];
            }

        }

    }];
}

-(void)popLoginViewController{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
}

-(void)popRegisterViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----选取头像----
//选取头像
-(void)chooseMyHeaderImage{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    KweakSelf(self);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakself.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [weakself presentViewController:weakself.imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakself.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        weakself.imagePickerController.navigationBar.barTintColor = [SDUtils hexStringToColor:KmainColor];
        weakself.imagePickerController.navigationBar.tintColor = [SDUtils hexStringToColor:KmainNotSelectColor];
        weakself.imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:KBoldFont(20)};
        [weakself presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cameraAction];
    [alertVC addAction:albumAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
        _userHeaderImageView.image = info[UIImagePickerControllerEditedImage];
        isChooseHeaderImage = YES;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([_addressTextField isFirstResponder]) {
        rects = self.view.frame.size.height - (_registerButton.frame.origin.y + _registerButton.frame.size.height+height);
    }
    
    if ([_phoneTextField isFirstResponder] || [_emailTextField isFirstResponder]) {
        rects = self.view.frame.size.height - (_emailTextField.frame.origin.y + _emailTextField.frame.size.height+height);
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



