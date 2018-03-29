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
@property (nonatomic, copy) NSString * pay_date;    //支付时间
@property (nonatomic, copy) NSString * create_date; //下单时间
@property (nonatomic, copy) NSString * create_time; //下单时间时间戳
@property (nonatomic, copy) NSString * pay_status_txt; //支付状态 已支付 未支付
@property (nonatomic, copy) NSString * orders_no; //订单编号
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * pay_price; //
@property (nonatomic, copy) NSString * pay_type; //支付类型  alipay
@property (nonatomic, copy) NSString * pay_type_txt;
@property (nonatomic, copy) NSString * pay_status;
@property (nonatomic, copy) NSString * goods_price; //商品价格
@property (nonatomic, strong) NSArray * goods;   //商品项目

@end


@interface AEGoodItem :DateCenter

@property (nonatomic, copy) NSString * goods_id; //商品id
@property (nonatomic, copy) NSString * goods_num; //商品条目
@property (nonatomic, copy) NSString * id; //商品id
@property (nonatomic, copy) NSString * goods_price; //商品价格
@property (nonatomic, copy) NSString * orders_no; //商品订单
@property (nonatomic, copy) NSString * goods_name; //商品名称
@property (nonatomic, copy) NSString * goods_type; //商品类型

@end

@interface AEScreeningItem : DateCenter
@property (nonatomic, copy) NSString * id; //条目id
@property (nonatomic, copy) NSString * type; //条目type
@property (nonatomic, copy) NSString * create_time; //时间
@property (nonatomic, copy) NSString * update_time; //更新时间

@property (nonatomic, copy) NSString * name; //条目分类
@property (nonatomic, copy) NSString * version; //条目版本
@property (nonatomic, copy) NSString * subject_type_name; //条目科目



//本地判断 是否已经选择
@property (nonatomic, assign) BOOL isSelect; //是否选择

@end

@interface AEMessageList :DateCenter
@property (nonatomic, copy) NSString * create_time; //
@property (nonatomic, copy) NSString * update_time; //
@property (nonatomic, copy) NSString * id; //
@property (nonatomic, copy) NSString * status; //0 未读 1 已读
@property (nonatomic, copy) NSString * title; // 标题
@property (nonatomic, copy) NSString * body; //副标题
@end

@interface AEStartExamItem : DateCenter
@property (nonatomic, copy) NSString * status; //0=>未开始 1 =>进行中 2=>完成考试
@property (nonatomic, copy) NSString * id; //  考试id
@property (nonatomic, copy) NSString * user_id; //用户id
@property (nonatomic, copy) NSString * subject_id; //‘科目id’,
@property (nonatomic, copy) NSString * exam_id; //ACAA的考卷id  客户端不用管

@end








