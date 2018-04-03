//
//  AETimerHelper.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/31.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AETimerHelper.h"

@interface AETimerHelper ()
@property(nonatomic,retain) dispatch_source_t timer;
@end

@implementation AETimerHelper


-(void)countDownTimeInterval:(NSTimeInterval)timeInterval completeBlock:(void (^)(NSString * timeString,BOOL finish))completeBlock{
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if (timeout<=0) { //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(@"0:00",YES);
                    });
                } else {
//                    int days = (int)(timeout/(3600*24));
//                    int hours = (int)((timeout-days*24*3600)/3600);
//                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
//                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    
                    int hours = (int)(timeout/3600);
                    int minute = (int)(timeout - hours*3600)/60;
                    int second = (int)(timeout -hours*3600 - minute*60);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock([NSString stringWithFormat:@"%d:%02d:%02d",hours,minute,second],NO);
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}
/**
 *  主动销毁定时器
 */
-(void)destoryTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
/**
 *  暂停定时器
 */
-(void)pauseTimer{
    if(_timer){
        dispatch_suspend(_timer);
    }
}
/**
 *  恢复定时器
 */
-(void)resumeTimer{
    if(_timer){
        dispatch_resume(_timer);
    }
}

@end
