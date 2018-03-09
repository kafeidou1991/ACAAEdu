//
//  NSTimer+addition.h
//  WYHomeLoopView
//
//  Created by 王启镰 on 16/5/5.
//  Copyright © 2016年 wanglijinrong. All rights reserved.
//


@interface NSTimer (addition)

- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;

+ (NSTimer *)wlscheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                        block:(void(^)(NSTimer *timer))block
                                      repeats:(BOOL)repeats;

@end
