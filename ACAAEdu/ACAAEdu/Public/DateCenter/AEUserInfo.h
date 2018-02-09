//
//  AEUserInfo.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "DateCenter.h"

#define User [AEUserInfo shareInstance]
//"token" : "5b0da604-2fd1-4999-a67a-6d9fdb3ac9c2",
//"status" : "normal",
//"uid" : "588712",
//"mobile" : "15565208789",
//"id_card" : "",
//"myidkey" : "",
//"lastloginip" : "3054637986",
//"lastlogintime" : 1518163633,
//"password" : "2aadbc69c6288272885eccbeb2898636",
//"card_type" : "0",
//"real_auth" : "2",
//"username" : "63a663ae3730ee0",
//"regip" : "3054637986",
//"regdate" : "1518082548",
//"salt" : "EDOlqW",
//"email" : "",
//"myid" : "",
//"secques" : ""
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
 状态
 */
@property (nonatomic, copy) NSString * username;
/**
邮箱
 */
@property (nonatomic, copy) NSString * email;
/**
 状态
 */
@property (nonatomic, copy) NSString * secques;
/**
 状态
 */
@property (nonatomic, copy) NSString * status;
/**
 状态
 */
@property (nonatomic, copy) NSString * id_card;
/**
 状态
 */
@property (nonatomic, copy) NSString * myidkey;
/**
 状态
 */
@property (nonatomic, copy) NSString * lastloginip;
/**
 状态
 */
@property (nonatomic, copy) NSString * password;
/**
 状态
 */
@property (nonatomic, copy) NSString * card_type;
/**
 状态
 */
@property (nonatomic, copy) NSString * real_auth;
/**
 状态
 */
@property (nonatomic, copy) NSString * regip;
/**
 状态
 */
@property (nonatomic, copy) NSString * regdate;
 
#pragma mark - methods
+ (instancetype)shareInstance;
- (void)removeLoginData;
- (void)save;

@end
