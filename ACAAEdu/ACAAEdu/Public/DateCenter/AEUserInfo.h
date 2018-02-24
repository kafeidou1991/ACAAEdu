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
/**
 英文名
 */
@property (nonatomic, copy) NSString * user_name_en;
/**
 性别  0=>女 1=>男 2=>保密
 */
@property (nonatomic, copy) NSString * gender;
/**
 生日
 */
@property (nonatomic, copy) NSString * birthday;
/**
 省
 */
@property (nonatomic, copy) NSString * province;
/**
 市
 */
@property (nonatomic, copy) NSString * city;
/**
 详细地址
 */
@property (nonatomic, copy) NSString * address;
/**
 邮政编码
 */
@property (nonatomic, copy) NSString * post_code;
/**
 固定电话号码
 */
@property (nonatomic, copy) NSString * phone_num;
/**
 传真号码
 */
@property (nonatomic, copy) NSString * fax_num;
/**
 职业 学生，教师，设计，工程师，管理人员，其他
 */
@property (nonatomic, copy) NSString * vocation;
/**
 学历 高中，大专，本科，学士，硕士，博士
 */
@property (nonatomic, copy) NSString * edu_level;
/**
 个人简介
 */
@property (nonatomic, copy) NSString * remark;


#pragma mark - methods
+ (instancetype)shareInstance;
//删除登录数据
- (void)removeLoginData;
//保存登录数据
- (void)save;

@end
