//
//  AEBaseController.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEBaseController : UIViewController

/**
 于加载网络请求方法
 */
- (void)afterProFun;

/**
 返回键返回

 @param sender button
 */
- (void)backAction:(UIBarButtonItem *)sender;

/**
 开启当前加载

 @param inView 当前view
 @param msgText 信息
 */
- (void)hudShow:(UIView *)inView msg:(NSString *)msgText;
/**
 关闭加载
 */
- (void)hudclose;

@end
