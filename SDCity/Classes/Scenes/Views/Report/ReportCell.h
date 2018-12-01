//
//  ReportCell.h
//  Starrunning
//
//  Created by wangweidong on 2017/7/31.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCell : UITableViewCell

//ReportCell是举报功能页面的Cell
@property(nonatomic,strong)UIButton *selectButton;

-(void)setMainTitleWithTitle:(NSString *)title;

@end
