//
//  NSObject+swizzling.h
//  TestNSArraySafe
//
//  Created by xuehan on 16/7/20.
//  Copyright © 2016年 xuehan. All rights reserved.
//


@interface NSObject (swizzling)
+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;

@end
