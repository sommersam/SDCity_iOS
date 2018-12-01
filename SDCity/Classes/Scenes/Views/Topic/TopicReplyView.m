//
//  TopicReplyView.m
//  SDCity
//
//  Created by wangweidong on 2017/12/21.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "TopicReplyView.h"
#import "HttpManager.h"
#import "UserManager.h"
@interface TopicReplyView()<UITextViewDelegate>

@property(nonatomic,strong)UIView *replyView;
@property(nonatomic,strong)UITextView *replyTextView;
@property(nonatomic,strong)UIButton *sendButton;

@end

@implementation TopicReplyView

-(instancetype)init{
    
    if (self = [super init]) {
       
        self.frame = CGRectMake(0, KmainHeight, KmainWidth, KmainHeight*2);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.isShow = NO;
        _replyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KmainWidth, 190)];
        _replyView.backgroundColor = [SDUtils hexStringToColor:@"f5f5f5"];
        _replyView.center =CGPointMake(KmainWidth/2.0, KmainHeight/2.0);
        [self addSubview: _replyView];

        _replyTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 15, KmainWidth-20, 80)];
        _replyTextView.layer.cornerRadius = 3.0f;
        _replyTextView.layer.masksToBounds = YES;
        _replyTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _replyTextView.layer.borderWidth = 0.5f;
        _replyTextView.backgroundColor = [UIColor whiteColor];
        _replyTextView.delegate = self;
        [_replyView addSubview: _replyTextView];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(KmainWidth-130,CGRectGetMaxY(_replyTextView.frame)+10, 120, 30);
        _sendButton.backgroundColor = [SDUtils hexStringToColor:@"#42c02e"];
        _sendButton.titleLabel.font = KBoldFont(15);
        _sendButton.layer.cornerRadius = 3.0f;
        _sendButton.layer.masksToBounds = YES;
        [_sendButton setTitle:@"发表回复" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[SDUtils hexStringToColor:@"d5d5d5"] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_replyView addSubview: _sendButton];
        [_sendButton addTarget:self action:@selector(sendReplyMessageAction) forControlEvents:UIControlEventTouchUpInside];

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
    return self;
}

-(void)showTopicReplyView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, KmainWidth, KmainHeight*2);
        [_replyTextView becomeFirstResponder];
    } completion:^(BOOL finished) {
        _isShow = YES;
    }];
}
-(void)removeTopicReplyView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, KmainHeight, KmainWidth, KmainHeight*2);
    } completion:^(BOOL finished) {
        _isShow = NO;
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [_replyView.layer convertPoint:point fromLayer:self.layer]; //get layer using containsPoint:

    if (![_replyView.layer containsPoint:point]) {
        [self removeTopicReplyView];
    }
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    CGFloat rects = self.frame.size.height - (_replyTextView.frame.origin.y + _replyTextView.frame.size.height+height);
    
    if (rects <= 0) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            CGRect frame = self.frame;
            
            frame.origin.y = rects;
            
            self.frame = frame;
            
        }];
        
    }
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [self removeTopicReplyView];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0 || textView.text == nil) {
        _sendButton.selected = NO;
    }else{
        _sendButton.selected = YES;
    }
}


#pragma mark ---- 发送回复消息 ----
-(void)sendReplyMessageAction{
    
    if (_sendButton.selected) {
        
        [HttpManager sendTopicReplyWithTopicId:_topicModel.topicId userId:[UserManager standardUserManager].userId replyId:_topicModel.createId content:_replyTextView.text andHandle:^(NSString *error, NSDictionary *result) {
            
            if (error == nil) {
                
                [self removeTopicReplyView];
                
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(successSendReplyMessageAction)]) {
                    [self.delegate successSendReplyMessageAction];
                }
            }
            
        }];
    }
    
}




@end
