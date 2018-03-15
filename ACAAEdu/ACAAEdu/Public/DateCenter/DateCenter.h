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


@interface AEMyOrderList :DateCenter
//{
//    "ip" : "2130706433",
//    "pay_time" : 1521036762,
//    "plat_form" : "",
//    "create_time" : 1521024483,
//    "pay_status_txt" : "已支付",
//    "pay_type" : "alipay",
//    "create_date" : "2018-03-14 18:48:03",
//    "send_type" : 0,
//    "send_price" : 0,
//    "pay_date" : "2018-03-14 22:12:42",
//    "delete_time" : null,
//    "goods" : [
//               {
//                   "goods_id" : 1,
//                   "goods_num" : 1,
//                   "id" : 20,
//                   "goods_price" : 0.01,
//                   "goods_attr" : "[]",
//                   "goods_name" : "Graphic Design",
//                   "goods_type" : "subject",
//                   "orders_no" : "201803141848038096"
//               }
//               ],
//    "orders_no" : "201803141848038096",
//    "id" : 16,
//    "pay_price" : 0.01,
//    "uid" : 121003,
//    "pay_type_txt" : "支付宝支付",
//    "pay_status" : 1,
//    "goods_price" : 0.01,
//    "send_address_id" : 0,
//    "send_time" : 0,
//    "remark" : "",
//    "send_status" : 0
@property (nonatomic, copy) NSString * pay_date;    //支付时间
@property (nonatomic, copy) NSString * create_date; //下单时间
@property (nonatomic, copy) NSString * create_time; //下单时间时间戳
@property (nonatomic, copy) NSString * pay_status_txt; //支付状态 已支付 未支付
@property (nonatomic, copy) NSString * orders_no;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * pay_price; //
@property (nonatomic, copy) NSString * pay_type; //支付类型  alipay
@property (nonatomic, copy) NSString * pay_type_txt;
@property (nonatomic, copy) NSString * pay_status;
@property (nonatomic, copy) NSString * goods_price; //商品价格
@property (nonatomic, strong) NSArray * goods;

@end










