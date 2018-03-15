//
//  AEOrderLabel.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

//此label 封装的是订单模块显示  左部是title 右边是内容

@interface AEOrderLabel : UIView

- (void)updateTitle:(NSString *)title content:(NSString *)des;

@end
