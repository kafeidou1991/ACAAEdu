//
//  UIButton+safeClick.m
//  WeiLicai
//
//  Created by zhoushnegjian on 2017/9/15.
//  Copyright © 2017年 WeiliCai. All rights reserved.
//

#import "UIButton+safeClick.h"

@implementation UIButton (safeClick)

+ (void)load {
    SEL originSel = @selector(sendAction:to:forEvent:);
    SEL swapSel   = @selector(sj_sendAction:to:forEvent:);
    
    Method orginMethod = class_getInstanceMethod(self, originSel);
    Method swapMethod  = class_getInstanceMethod(self, swapSel);
    
    BOOL isAdd = class_addMethod(self, originSel, method_getImplementation(swapMethod), method_getTypeEncoding(swapMethod));
    if (isAdd) {
        class_replaceMethod(self, swapSel, method_getImplementation(orginMethod), method_getTypeEncoding(orginMethod));
    }else {
        method_exchangeImplementations(orginMethod, swapMethod);
    }
}

- (void)sj_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    self.userInteractionEnabled = NO;
    [self sj_sendAction:action to:target forEvent:event];
    self.userInteractionEnabled = YES;
}

@end
