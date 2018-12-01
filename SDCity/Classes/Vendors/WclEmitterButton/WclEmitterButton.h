//
//  WclEmitterButton.h
//  WclEmitterButton
//
//  Created by 王崇磊 on 16/4/26.
//  Copyright © 2016年 王崇磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WclEmitterButton : UIButton

//两种不同的CAEmitterLayer
@property (strong, nonatomic) CAEmitterLayer *chargeLayer;
@property (strong, nonatomic) CAEmitterLayer *explosionLayer;

@property(nonatomic,assign)BOOL isHaveAnimation;//设置selected属性 是否有动画效果,默认没有,需要手动打开

@end
