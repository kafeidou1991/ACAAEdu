//
//  JJWBase.h
//  JiuJiuWu
//
//  Created by 张竟巍 on 2017/9/12.
//  Copyright © 2017年 张竟巍. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STTR_ater_on @"请稍后..."

typedef void (^ALertCompletion)(BOOL compliont);

@interface AEBase : NSObject
//构造器 快速创建
+ (UIBarButtonItem *)createCustomBarButtonItem:(id)target action:(SEL)action title:(NSString *)title;
+ (UIBarButtonItem *)createCustomBarButtonItem:(id)target action:(SEL)action image:(NSString *)imagestr;
+ (UIButton *)createButton:(CGRect) frame type:(UIButtonType)buttonType title:(NSString *)title;
+ (UILabel *)createLabel:(CGRect) frame font:(UIFont *)font text:(NSString *)text defaultSizeTxt:(NSString *)sizeDefault color:(UIColor *)txtColor backgroundColor:(UIColor *)backgroundColor alignment:(NSTextAlignment)align;
/**
 提醒
 
 @param msg 文案
 @param completion 回调
 */
+ (void)alertMessage:(NSString*)msg cb:(ALertCompletion) completion;

/**
 至于Window的加载框 主要用于购买

 @param msgText 文案
 */
+ (void)hudShowInWindowMsg:(NSString *)msgText;

/**
 主动消失
 */
+ (void)hudclose;

@end
