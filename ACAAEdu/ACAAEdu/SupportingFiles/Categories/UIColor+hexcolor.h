//
//  UIColor+hexcolor.h
//  IHaoMu
//
//  Created by  wuhiwi on 16/11/2.
//  Copyright © 2016年 ihaomu.com. All rights reserved.
//


@interface UIColor (hexcolor)

// 将十六进制颜色的字符串转化为复合iphone/ipad的颜色
// 字符串为"FFFFFF"
+ (UIColor *)colorWithHex:(NSString *)hexColor;

+ (UIColor *)colorWithHex:(NSString *)hexColor alpha:(CGFloat)alpha;

@end
