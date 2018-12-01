//
//  AddPhotoViewController.m
//  SDCity
//
//  Created by wangweidong on 2018/1/5.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "AddPhotoViewController.h"
#import "LBPhotoBrowserManager.h"
#import "UIView+LBFrame.h"
#import "HttpManager.h"
#import "UserManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface AddPhotoViewController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    BOOL isSelectPhoto;
}

@property(nonatomic,strong)UIButton *exitButton;
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UIButton *titleButton;
@property(nonatomic,strong)UITextField *titleTextField;
@property(nonatomic,strong)UIButton *sendButton;
@property(nonatomic,strong)UIImagePickerController *imagePickerController;

@property (nonatomic , assign)BOOL hideStatusBar;


@end


@implementation AddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.exitButton];
    [self.view addSubview:self.mainImageView];
    [self.view addSubview:self.titleButton];
    [self.view addSubview:self.titleTextField];
    [self.view addSubview:self.sendButton];

    self.view.backgroundColor = [SDUtils hexStringToColor:@"fafafa"];
    
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
        [_exitButton addTarget:self action:@selector(dismissLoginViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}

-(UIImageView *)mainImageView{
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KmainWidth *0.2, CGRectGetMaxY(_exitButton.frame)+10, KmainWidth *0.6, KmainWidth *0.6)];
        _mainImageView.image = [UIImage imageNamed:@"选取图片占位图"];
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _mainImageView.layer.borderWidth = 1.0f;
        _mainImageView.layer.cornerRadius = 5.0f;
        _mainImageView.layer.masksToBounds = YES;
        _mainImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPhotoBrowserAction)];
        [_mainImageView addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(chooseMyHeaderImage)];
        [_mainImageView addGestureRecognizer:longPressGestureRecognizer];
        isSelectPhoto = NO;
    }
    return _mainImageView;
}


-(UIButton *)titleButton{
    
    if (_titleButton == nil) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(20, CGRectGetMaxY(_mainImageView.frame)+10, KmainWidth-40, 45);
        _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _titleButton.userInteractionEnabled = NO;
        [_titleButton setImage:[UIImage imageNamed:@"新增话题标题"] forState:UIControlStateNormal];
        [_titleButton setTitle:@" 描述" forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _titleButton;
}

-(UITextField *)titleTextField{
    
    if (_titleTextField == nil) {
        _titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleButton.frame)+5, KmainWidth-40, 45)];
        _titleTextField.backgroundColor = [UIColor whiteColor];
        _titleTextField.placeholder = @"一两句描述下图片";
        _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _titleTextField.delegate = self;
        UIView *leftView = [[UIView alloc]init];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 10, 45);
        _titleTextField.leftViewMode = UITextFieldViewModeAlways;
        _titleTextField.leftView = leftView;
        [_titleTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return _titleTextField;
}


-(UIButton *)sendButton{
    
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(20, CGRectGetMaxY(_titleTextField.frame)+20, KmainWidth-40, 45);
        _sendButton.layer.cornerRadius = 5.0f;
        _sendButton.layer.masksToBounds = YES;
        [_sendButton setTitle:@" 发布" forState:UIControlStateNormal];
        [_sendButton setImage:[UIImage imageNamed:@"发送图标"] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[SDUtils  hexStringToColor:@"83bbe0"]];
        [_sendButton addTarget:self action:@selector(sendAciton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


-(UIImagePickerController *)imagePickerController{
    
    if (_imagePickerController == nil) {
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
    }
    
    return _imagePickerController;
}



#pragma mark ----选取图片----
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
        
        _mainImageView.image = info[UIImagePickerControllerOriginalImage];
        isSelectPhoto = YES;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- 预览图片 ----

-(void)showPhotoBrowserAction{
    
    if (isSelectPhoto) {
        self.hideStatusBar = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        NSMutableArray *items = @[].mutableCopy;
        LBPhotoLocalItem *item = [[LBPhotoLocalItem alloc]initWithImage:_mainImageView.image frame:_mainImageView.frame];
        [items addObject:item];
        [[LBPhotoBrowserManager defaultManager] showImageWithLocalItems:items selectedIndex:0 fromImageViewSuperView:self.view];
        
        KweakSelf(self);
        [[LBPhotoBrowserManager defaultManager] addPhotoBrowserWillDismissBlock:^{
            weakself.hideStatusBar = NO;
            [weakself setNeedsStatusBarAppearanceUpdate];
        }];
    }
    
}




#pragma mark ----上传图片数据----

-(void)sendAciton{
    
    if (!isSelectPhoto) {
        [SVProgressHUD showErrorWithStatus:@"没有图片传毛线,亲"];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
    
    
    if ([SDUtils isEmptyWithTestString:_titleTextField.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"随意说一句呗,亲"];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"图片上传中..."];
    [HttpManager addPhotoWithUserId:[UserManager standardUserManager].userId title:_titleTextField.text details:_titleTextField.text image:_mainImageView.image andHandle:^(NSString *error, NSDictionary *result) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
            [SVProgressHUD dismissWithDelay:1.0];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"图片上传失败!"];
            [SVProgressHUD dismissWithDelay:1.0];
        }
    }];
    
}


#pragma mark ---- 键盘事件 ----

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_titleTextField resignFirstResponder];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    CGFloat rects = self.view.frame.size.height - (_titleTextField.frame.origin.y + _titleTextField.frame.size.height+height);
    
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



#pragma mark ----返回事件----

-(void)dismissLoginViewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)prefersStatusBarHidden {
    return _hideStatusBar;
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


