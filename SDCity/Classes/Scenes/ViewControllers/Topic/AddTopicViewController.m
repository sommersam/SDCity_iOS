//
//  AddTopicViewController.m
//  SDCity
//
//  Created by wangweidong on 2018/1/4.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "AddTopicViewController.h"
#import "HttpManager.h"
#import "UserManager.h"
@interface AddTopicViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong)UIButton *exitButton;
@property(nonatomic,strong)UIButton *titleButton;
@property(nonatomic,strong)UITextField *titleTextField;
@property(nonatomic,strong)UIButton *contentButton;
@property(nonatomic,strong)UITextView *contentView;
@property(nonatomic,strong)UIButton *sendButton;

@end

@implementation AddTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.exitButton];
    [self.view addSubview:self.titleButton];
    [self.view addSubview:self.titleTextField];
    [self.view addSubview:self.contentButton];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.sendButton];

    self.view.backgroundColor = [SDUtils hexStringToColor:@"fafafa"];

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

-(UIButton *)titleButton{
    
    if (_titleButton == nil) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(20, CGRectGetMaxY(_exitButton.frame)+20, KmainWidth-40, 45);
        _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _titleButton.userInteractionEnabled = NO;
        [_titleButton setImage:[UIImage imageNamed:@"新增话题标题"] forState:UIControlStateNormal];
        [_titleButton setTitle:@" 新话题标题" forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _titleButton;
    
}

-(UITextField *)titleTextField{
    
    if (_titleTextField == nil) {
        _titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleButton.frame)+5, KmainWidth-40, 45)];
        _titleTextField.backgroundColor = [UIColor whiteColor];
        _titleTextField.placeholder = @"新话题标题";
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

-(UIButton *)contentButton{
    
    if (_contentButton == nil) {
        _contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _contentButton.frame = CGRectMake(20, CGRectGetMaxY(_titleTextField.frame)+5, KmainWidth-40, 45);
        _contentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _contentButton.userInteractionEnabled = NO;
        [_contentButton setImage:[UIImage imageNamed:@"新增话题内容"] forState:UIControlStateNormal];
        [_contentButton setTitle:@" 新话题内容" forState:UIControlStateNormal];
        [_contentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _contentButton;
}

-(UITextView *)contentView{
    
    if (_contentView == nil) {
        
        _contentView = [[UITextView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(_contentButton.frame)+5, KmainWidth-40, 80)];
        _contentView.layer.cornerRadius = 3.0f;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentView.layer.borderWidth = 0.5f;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.delegate = self;
    }
    
    return _contentView;
}



-(UIButton *)sendButton{
    
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(20, CGRectGetMaxY(_contentView.frame)+20, KmainWidth-40, 45);
        _sendButton.layer.cornerRadius = 5.0f;
        _sendButton.layer.masksToBounds = YES;
        [_sendButton setTitle:@"发布新话题" forState:UIControlStateNormal];
        [_sendButton setImage:[UIImage imageNamed:@"发送图标"] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[SDUtils  hexStringToColor:@"83bbe0"]];
        [_sendButton addTarget:self action:@selector(sendAciton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

#pragma mark ----新增话题----

-(void)sendAciton{

    if ([SDUtils isEmptyWithTestString:_titleTextField.text] || [SDUtils isEmptyWithTestString:_contentView.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"标题和内容缺一不可,亲"];
        [SVProgressHUD dismissWithDelay:1.0];
        
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"话题发布中..."];
    [HttpManager sendTopicWithUserId:[UserManager standardUserManager].userId title:_titleTextField.text contect:_contentView.text label:@"说说" andHandle:^(NSString *error, NSDictionary *result) {
       
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功!"];
            [SVProgressHUD dismissWithDelay:1.0];
            [self dismissViewControllerAnimated:YES completion:nil];

        }else{
            [SVProgressHUD showErrorWithStatus:@"发布失败!"];
            [SVProgressHUD dismissWithDelay:1.0];
        }
    }];
    
}



#pragma mark ----返回事件----

-(void)dismissLoginViewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
