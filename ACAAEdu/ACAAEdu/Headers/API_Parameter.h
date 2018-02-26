//
//  API_Parameter.h
//  YZF
//
//  Created by 张竟巍 on 2017/5/3.
//  Copyright © 2017年 Beijing Yi Cheng Agel Ecommerce Ltd. All rights reserved.
//

#ifndef API_Parameter_h
#define API_Parameter_h

#pragma mark ---------------------- 域名 ---------------------------
#ifdef DEBUG //开发环境
//0 测试环境  1 正式环境
#define environment 1

#if environment
static NSString * const baseUrl = @"https://api.yongqingjt.com/yinzhifuapi/";
#else
static NSString * const baseUrl = @"http://test.yongqingjt.com:8080/yinzhifuapi/"; //101.201.117.15:8080
#endif

#else //发布环境
static NSString * const baseUrl = @"https://api.yongqingjt.com/yinzhifuapi/";
#endif

#pragma mark ---------------------- 参数字段、功能 ----------------------------
//登录
#define kLogin @"mobile/user/login"
//注册
#define kRegister @"mobile/user/register"
//找回密码
#define kFindPassword @"mobile/user/findpwd"
//获取图形验证码
#define kCaptcha @"mobile/user/captcha"
//绑定邮箱
#define kBindEmail @"mobile/user/bindEmail"
//绑定手机
#define kBindMobile @"mobile/user/bindMobile"
//获取验证码
#define kVerifyCode @"mobile/user/verify"
//上传用户资料
#define kProfile @"mobile/user/profile"
//获取用户资料
#define kGetProfile @"mobile/user/getProfile"
//绑定身份证
#define kBindIdCard @"mobile/user/bindIdCard"




#endif /* API_Parameter_h */
