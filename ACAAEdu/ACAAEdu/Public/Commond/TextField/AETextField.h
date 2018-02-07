//
//  AETextField.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/7.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AETextField : UITextField

@property (nonatomic, assign) IBInspectable NSInteger lengthLimit;
@property (nonatomic, assign, getter=isSafety)   IBInspectable BOOL safety;
@property (nonatomic, assign, getter=isPhoneField) IBInspectable BOOL phoneField;
@property (nonatomic, assign, getter=isBankCardField) IBInspectable BOOL bankCardField;
@property (nonatomic, assign, getter=isIdCardField) IBInspectable BOOL idCardField;



@property (nonatomic, assign) IBInspectable NSInteger placeholderFontSize;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

@end
