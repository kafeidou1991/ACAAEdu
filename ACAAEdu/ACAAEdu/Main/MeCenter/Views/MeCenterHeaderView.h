//
//  MeCenterHeaderView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCenterHeaderView : UIView
//更新头部信息
- (void)updateheaderInfo;
/**
 点击登录按钮
 @param sender 按钮
 */
- (IBAction)loginClick:(UITapGestureRecognizer *)sender;


/**
 游客模式下登录成功
 */
- (void)updateVisitorHeaderInfo;
@end
