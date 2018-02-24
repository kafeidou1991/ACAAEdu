//
//  AEUserInfo.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "DateCenter.h"

@interface AEUserInfo : DateCenter
/**
 是否登录
 */
@property (nonatomic, assign) BOOL isLogin;
/**
 用户令牌
 */
@property (nonatomic, copy) NSString * token;
/**
 用户id
 */
@property (nonatomic, copy) NSString * uid;
/**
 用户手机号
 */
@property (nonatomic, copy) NSString * mobile;
/**
 邮箱
 */
@property (nonatomic, copy) NSString * email;
/**
 身份证
 */
@property (nonatomic, copy) NSString * id_card;
/**
 昵称
 */
@property (nonatomic, copy) NSString * username;


#pragma mark - methods
+ (instancetype)shareInstance;
//删除登录数据
- (void)removeLoginData;
//保存登录数据
- (void)save;

@end
