//
//  UIControl+AcceptEventInterval.h
//  wyzc
//
//  Created by WYZC on 16/4/26.
//  Copyright © 2016年 北京我赢科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
/*
 * 解决连续点击问题。只需要在程序里加入这部分代码即可
 */
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_ignoreEvent = "UIControl_ignoreEvent";
@interface UIControl (AcceptEventInterval)
@property (nonatomic, assign) NSTimeInterval uxy_acceptEventInterval;   // 可以用这个给重复点击加间隔
@property (nonatomic, assign) BOOL uxy_ignoreEvent;

@end
