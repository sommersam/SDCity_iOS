//
//  LeftMenuView.h
//  SDCity
//
//  Created by wangweidong on 2017/12/19.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuViewDelegate<NSObject>

@optional
//选择某个菜单的选项下标
-(void)selectMenuCellWithIndexPath:(NSInteger)indexPath;

@end

@interface LeftMenuView : UIView

@property(nonatomic,weak)id<LeftMenuViewDelegate> delegate;
@property(nonatomic,assign)BOOL isShow;
@property(nonatomic,strong)UIButton *loginButton;

-(void)loadUserInfomationAction;
-(void)showLeftMenuView;
-(void)removeLeftMenuView;

@end
