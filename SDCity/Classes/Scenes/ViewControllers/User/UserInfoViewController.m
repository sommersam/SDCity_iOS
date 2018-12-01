//
//  UserInfoViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/29.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserManager.h"
#import "UserInfoCell.h"
#import "HttpManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UserInfoCellDelegate>{
    
    BOOL isChooseHeaderImage;
    NSIndexPath *editingIndexPath;
}
@property(nonatomic,strong)NSMutableArray *userInfoArray;

@property(nonatomic,strong)UIImageView *userHeaderImageView;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIImagePickerController *imagePickerController;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableView];
    [self loadUserInfoDataSource];
    [self loadNavgationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    isChooseHeaderImage = NO;

    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}

-(void)loadNavgationBar{
    
    self.navigationItem.title = @"个人中心";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:KBoldFont(20),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAciton)];
    self.navigationItem.leftBarButtonItem.tintColor = KmyColor(240, 240, 240);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Affirm"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(updateUserInfoAction)];
}

-(void)popViewControllerAciton{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Senty" size:32],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadUserInfoDataSource{
    
    _userInfoArray = [NSMutableArray arrayWithCapacity:8];
    [_userInfoArray addObject:[UserManager standardUserManager].userName?[UserManager standardUserManager].userName:@"未知"];
    [_userInfoArray addObject:[UserManager standardUserManager].roleName?[UserManager standardUserManager].roleName:@"未知"];
    [_userInfoArray addObject:[UserManager standardUserManager].phone?[UserManager standardUserManager].phone:@"未知"];
    [_userInfoArray addObject:[UserManager standardUserManager].email?[UserManager standardUserManager].email:@"未知"];
    [_userInfoArray addObject:[UserManager standardUserManager].address?[UserManager standardUserManager].address:@"未知"];
    [_mainTableView reloadData];
}

#pragma mark ---- 懒加载 ----
-(UIImagePickerController *)imagePickerController{
    
    if (_imagePickerController == nil) {
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    
    return _imagePickerController;
}


-(UITableView *)mainTableView{
    
    if (_mainTableView == nil) {
        
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusHeight + 44, KmainWidth, KmainHeight-StatusHeight-44) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = NO;
        _mainTableView.showsVerticalScrollIndicator = NO;
        
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            _mainTableView.separatorInset = UIEdgeInsetsZero;
        }
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            _mainTableView.layoutMargins = UIEdgeInsetsZero;
        }
        [_mainTableView registerClass:[UserInfoCell class] forCellReuseIdentifier:@"UserInfoCell"];
        
    }
    
    return _mainTableView;
}

#pragma mark ---- UITableViewDataSoure 和 UITableViewDelegate ----

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    NSArray *titleArray = @[@"  昵称",@"  身份",@"  电话",@"  邮箱",@"  地址"];
    NSArray *imageArray = @[@"User",@"Pentagram",@"Phone",@"Mail",@"Location"];
    [cell.titleButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:UIControlStateNormal];
    [cell.titleButton setTitle:titleArray[indexPath.row] forState:UIControlStateNormal];
    cell.detailTextField.text = _userInfoArray[indexPath.row];
    if (indexPath.row == 1) {
        cell.detailTextField.userInteractionEnabled = NO;
    }else{
        cell.detailTextField.userInteractionEnabled = YES;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KmainWidth, 120)];
    headerView.backgroundColor = [UIColor whiteColor];
    _userHeaderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"默认用户头像"]];
    _userHeaderImageView.frame = CGRectMake(KmainWidth/2-50,10, 100, 100);
    _userHeaderImageView.layer.cornerRadius = 50.0f;
    _userHeaderImageView.layer.masksToBounds = YES;
    _userHeaderImageView.layer.borderColor = [SDUtils hexStringToColor:KmainNotSelectColor].CGColor;
    _userHeaderImageView.layer.borderWidth = 3.0f;
    _userHeaderImageView.userInteractionEnabled = YES;
    if ([UserManager standardUserManager].headerURL != nil) {
        [_userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager standardUserManager].headerURL]];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseMyHeaderImage)];
    [_userHeaderImageView addGestureRecognizer:tap];
    [headerView addSubview:_userHeaderImageView];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 120.0f;
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

#pragma mark ---- 更新用户的信息 ----

-(void)updateUserInfoAction{
    
    UserInfoCell *nameCell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UserInfoCell *phoneCell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UserInfoCell *emailCell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UserInfoCell *locationCell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];

    [SVProgressHUD showWithStatus:@"用户信息提交中"];
    [HttpManager userUpdateInfoActionWithUserId:[UserManager standardUserManager].userId name:nameCell.detailTextField.text email:emailCell.detailTextField.text address:locationCell.detailTextField.text phone:phoneCell.detailTextField.text headerimg:isChooseHeaderImage?_userHeaderImageView.image:nil andHandle:^(NSString *error, NSDictionary *result) {
        NSLog(@"%@",result);
        if (error == nil) {
            [HttpManager getUserInfoActionWithUserId:[UserManager standardUserManager].userId andHandle:^(NSString *error, NSDictionary *result) {
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                [SVProgressHUD dismissWithDelay:0.8];
            }];
        }
    }];
    
    
}


#pragma mark ---- 根据不同的Cell来上顶TableView ----

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGFloat rects = self.view.frame.size.height - ( 120 + (editingIndexPath.row+1)*50.0+height+StatusHeight+44+10);
    NSLog(@"%f",rects);
    if (rects <= 0) {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = rects;
            self.view.frame = frame;
        }];
    }
}


-(void)detailTextFieldShouldBeginEditingWithCell:(UserInfoCell *)cell{
    
    editingIndexPath = [_mainTableView indexPathForCell:cell];
}
-(void)detailTextFieldShouldEndEditingWithCell:(UserInfoCell *)cell{
    
    [UIView animateWithDuration:0.1 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
}


@end
