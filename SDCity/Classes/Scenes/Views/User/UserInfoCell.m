//
//  UserInfoCell.m
//  SDCity
//
//  Created by wangweidong on 2017/12/29.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "UserInfoCell.h"
#define CellHeight 50.0f

@interface UserInfoCell()<UITextFieldDelegate>


@end

@implementation UserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(10, 0, 200, CellHeight);
        _titleButton.titleLabel.font = KBoldFont(16);
        _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_titleButton];
        
        _detailTextField = [[UITextField alloc]initWithFrame:CGRectMake(200, 0, KmainWidth-210, CellHeight)];
        _detailTextField.textAlignment = NSTextAlignmentRight;
        _detailTextField.delegate = self;
        _detailTextField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_detailTextField];
    }
    
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(detailTextFieldShouldBeginEditingWithCell:)]) {
        [self.delegate detailTextFieldShouldBeginEditingWithCell:self];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(detailTextFieldShouldEndEditingWithCell:)]) {
        [self.delegate detailTextFieldShouldEndEditingWithCell:self];
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
