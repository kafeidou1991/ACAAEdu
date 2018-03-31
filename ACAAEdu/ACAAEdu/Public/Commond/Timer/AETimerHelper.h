//
//  AETimerHelper.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/31.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AETimerHelper : NSObject


/**
 定时器任务

 @param timeInterval 定时时间
 @param completeBlock 完成回调  格式 ： 34:45  (分 秒)
 */
-(void)countDownTimeInterval:(NSTimeInterval)timeInterval completeBlock:(void (^)(NSString * timeString,BOOL finish))completeBlock;
/**
 销毁定时器
 */
-(void)destoryTimer;
/**
 *  暂停定时器
 */
-(void)pauseTimer;
/**
 *  恢复定时器
 */
-(void)resumeTimer;


@end
