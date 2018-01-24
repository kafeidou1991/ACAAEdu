//
//  AEUserInfo.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEUserInfo.h"
#define LOGIN_DATA_KEY @"ACAA-EDU-KEY"

static AEUserInfo * info = nil;
@interface AEUserInfo ()<NSCopying>

@end



@implementation AEUserInfo

+(instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self getInfo];
        if (!info) {
            info = [AEUserInfo new];
        }
    });
    return info;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    return [AEUserInfo shareInstance];
}
- (id)copyWithZone:(NSZone *)zone {
    return [AEUserInfo shareInstance];
}

-(void)removeLoginData {
    info = [AEUserInfo new];
    _isLogin =NO;
    [self remove];
}

- (void)save {
    NSMutableDictionary *dic = [self yy_modelToJSONObject];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dic forKey:LOGIN_DATA_KEY];
    [userDefaults synchronize];
    _isLogin = YES;
}

+ (void)getInfo {
    info = [[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_DATA_KEY];
}

- (void)remove {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:LOGIN_DATA_KEY];
    [userDefaults synchronize];
}






@end