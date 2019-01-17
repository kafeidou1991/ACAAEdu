//
//  API_Parameter.h
//  YZF
//
//  Created by 张竟巍 on 2017/5/3.
//  Copyright © 2017年 Beijing Yi Cheng Agel Ecommerce Ltd. All rights reserved.
//

#ifndef API_Parameter_h
#define API_Parameter_h

#pragma mark ---------------------- 用户----------------------------
//登录
#define kLogin @"mobile/user/login"
//退出登录
#define kLogout @"mobile/user/logout"
//注册
#define kRegister @"mobile/user/register"
//账户是否存在
#define kIsexists @"mobile/register/isexists"
//找回密码
#define kFindPassword @"mobile/user/findpwd"
//获取图形验证码
#define kCaptcha @"mobile/user/captcha"
//绑定邮箱
#define kBindEmail @"mobile/user/bindEmail"
//绑定手机
#define kBindMobile @"mobile/user/bindMobile"
//解绑手机号 邮箱
#define kUnBindMobileOrEmile @"mobile/user/unbind"
//获取验证码 (修改密码时用)
#define kVerifyCode @"mobile/user/verify"
//上传用户资料
#define kProfile @"mobile/user/profile"
//获取用户资料
#define kGetProfile @"mobile/user/getProfile"
//绑定身份证
#define kBindIdCard @"mobile/user/bindIdCard"

#pragma mark ---------------------- 新注册流程----------------------------
//注册账号
#define kRegisterAccount @"mobile/register/account"
//设置昵称
#define kRegisterPWD  @"mobile/register/password"
//注册绑定身份证
#define kRegisterBindIdCard @"mobile/register/idcard"
//确认注册
#define kRegisterCreate @"mobile/register/create"
//获取验证码（注册时获取验证码）(账户没有注册时用)
#define kRegisterVerifyCode @"mobile/register/verify"
#pragma mark ---------------------- 科目----------------------------
//首页推荐
#define kRecommendSubjectList @"mobile/subject/recommendsubjectlist"
//首页Banner
#define kBanner @"mobile/system/banner"
//科目列表
#define kIndexList @"mobile/subject/index"
//ACAA考试列表
#define kAcaaList  @"mobile/subject/acaa"
//AUTO考试列表
#define kAutodeskList  @"mobile/subject/autodesk"
//筛选类别列表
#define kCategoryList @"mobile/subject_category/index"
//筛选版本列表
#define kVersionList @"mobile/subject_version/index"
//筛选科目列表
#define kSubjectList @"mobile/subject/subjectlist"
//我的模考列表
#define kMyTestExamList @"mobile/user_exam/index"

#pragma mark ---------------------- 考试部分相关----------------------------
//开始考试
#define kStartExamPaper @"mobile/exam/startExam"
//获取部分考试（题型）
#define kPartExamPaper @"mobile/exam/getExamPart"
//获取部分考试试题
#define kPartExamQuestion @"mobile/exam/getExamQuestion"
//提交单个题目答案
#define kSubmitQuestion @"mobile/exam/submitQuestion"
//提交整个考卷
#define kSubmitExam     @"mobile/exam/submitExam"
//获取考试成绩评价
#define kExamEvaluate   @"mobile/exam/evaluate"

#pragma mark ---------------------- 订单----------------------------
//订单列表
#define kOrderList @"mobile/shop/orders"
//生成订单
#define kCreatOrder @"mobile/shop/order"
//删除订单
#define kDeleteOrder @"mobile/shop/order_del"
//验证凭据
#define kValidateReceipt  @"mobile/shop/apple"

#pragma mark ---------------------- 通知消息----------------------------
#define kMessageList @"mobile/message/index"


#endif /* API_Parameter_h */
