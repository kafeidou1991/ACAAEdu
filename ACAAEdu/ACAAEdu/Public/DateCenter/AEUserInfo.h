//
//  AEUserInfo.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "DateCenter.h"

#define User [AEUserInfo shareInstance]

@interface AEUserInfo : DateCenter
/**
 是否登录
 */
@property (nonatomic, assign) BOOL isLogin;//是否登录
/**
 用户令牌
 */
@property (nonatomic, copy) NSString * token;
/**
 用户id
 */
@property (nonatomic, copy) NSString * user_id;//用户id
/**
 用户手机号
 */
@property (nonatomic, copy) NSString * mobile;//用户注册手机号

#pragma mark - methods
+ (instancetype)shareInstance;
- (void)removeLoginData;
- (void)save;

@end
