//
//  DateCenter.h
//  YZF
//
//  Created by 张竟巍 on 2017/3/27.
//  Copyright © 2017年 Beijing Yi Cheng Agel Ecommerce Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PageItem;
@interface DateCenter : NSObject
@property (nonatomic, copy) NSString * current_page;
@property (nonatomic, copy) NSString * last_page;
@property (nonatomic, copy) NSString * per_page;
@property (nonatomic, copy) NSString * total;//页数
@end


@interface AEAppVersion : DateCenter
@property (nonatomic, copy) NSString * version_id; //公告
@property (nonatomic, copy) NSString * version_code; //公告
@property (nonatomic, copy) NSString * version_name; //公告
@property (nonatomic, copy) NSString * is_force; //公告
@property (nonatomic, copy) NSString * content; //公告
@property (nonatomic, copy) NSString * dl_url; //请求的地址
@property (nonatomic, copy) NSString * is_open; //是否开发审核开关
@end

//用户资料
@interface AEUserProfile :DateCenter
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

@end













