//
//  UIFont+wl.m
//  WeiLicai
//
//  Created by zhoushengjian on 2017/5/31.
//  Copyright © 2017年 WeiliCai. All rights reserved.
//

#import "UIFont+wl.h"

@implementation UIFont (wl)

+ (UIFont *)wlfontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    if (font) {
        return font;
    }else {
        return [UIFont systemFontOfSize:fontSize];
    }
}


@end
