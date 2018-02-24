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

+ (UIBarButtonItem *)createCustomBarButtonItem:(id)target action:(SEL)action title:(NSString *)title;
+ (UIBarButtonItem *)createCustomBarButtonItem:(id)target action:(SEL)action image:(NSString *)imagestr;
+ (UIButton *) createButton:(CGRect) frame type:(UIButtonType)buttonType title:(NSString *)title;
//构造器
+ (UILabel *)  createLabel:(CGRect) frame font:(UIFont *)font text:(NSString *)text defaultSizeTxt:(NSString *)sizeDefault color:(UIColor *)txtColor backgroundColor:(UIColor *)backgroundColor alignment:(NSTextAlignment)align;

//提醒
+ (void)alertMessage:(NSString*)msg cb:(ALertCompletion) completion;
@end
