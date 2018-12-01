//
//  UserInfoCell.h
//  SDCity
//
//  Created by wangweidong on 2017/12/29.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoCell;
@protocol UserInfoCellDelegate<NSObject>

@optional
-(void)detailTextFieldShouldBeginEditingWithCell:(UserInfoCell *)cell;
-(void)detailTextFieldShouldEndEditingWithCell:(UserInfoCell *)cell;

@end

@interface UserInfoCell : UITableViewCell

//UserInfoCell是用户信息页面的Cell
@property(nonatomic,strong)UIButton *titleButton;
@property(nonatomic,strong)UITextField *detailTextField;
@property(nonatomic,weak)id<UserInfoCellDelegate> delegate;

@end
