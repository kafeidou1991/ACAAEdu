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
 姓名
 */
@property (nonatomic, copy) NSString * user_name;
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
@property (nonatomic, copy) NSString * pay_status; //0 未支付需要走支付流程  1 支付完成直接进入购买的商品列表
@property (nonatomic, copy) NSString * goods_price; //商品价格
@property (nonatomic, strong) NSArray * goods;   //商品项目

@end

@class AEExamItem;
@interface AEGoodItem :DateCenter
@property (nonatomic, copy) NSString * goods_id; //商品id
@property (nonatomic, copy) NSString * goods_num; //商品条目
@property (nonatomic, copy) NSString * id; //商品id
@property (nonatomic, copy) NSString * goods_price; //商品价格
@property (nonatomic, copy) NSString * orders_no; //商品订单
@property (nonatomic, copy) NSString * goods_name; //商品名称
@property (nonatomic, copy) NSString * goods_type; //商品类型
@property (nonatomic, strong) AEExamItem * goods_attr_data; //商品信息

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


@interface AEExamQuestionItem :DateCenter <NSCopying>
@property (nonatomic, copy) NSString * status; //1 未考完 2已考完
@property (nonatomic, copy) NSString * part_num; // 题目数量
@property (nonatomic, copy) NSString * id; // 用户考卷部分id
@property (nonatomic, copy) NSString * part_type; //考题类型，1-基础题，2-操作题
@property (nonatomic, copy) NSString * start_time; //开始考试时间
@property (nonatomic, copy) NSString * part_name; //考题类型名称
@property (nonatomic, copy) NSString * subject_id; //科目id’,
@property (nonatomic, copy) NSString * user_id; //用户id
@property (nonatomic, copy) NSString * exam_id; //用户考卷id 客户端不用管
@property (nonatomic, copy) NSString * part_time; // 考试限制时长 单位秒
@property (nonatomic, copy) NSString * count_down_time; //剩余考试时间 单位秒

@property (nonatomic, strong) NSArray * question; //试题数组

//本地使用
@property (nonatomic, copy) NSString * questionName; // 题干类型 1-判断题2-单选题3-复选题4-匹配题11-操作题【4暂无】

@end

@interface AEQuestionRresult :DateCenter

@property (nonatomic, copy) NSString * id; //试题id
@property (nonatomic, copy) NSString * category; //类别
@property (nonatomic, copy) NSString * sheet_id; //题目id
@property (nonatomic, copy) NSString * answer; // 答案 多个逗号分隔
@property (nonatomic, copy) NSString * exam_id; //考卷id客户端不用管
@property (nonatomic, copy) NSString * user_id; //用户id
@property (nonatomic, copy) NSString * type; //考题类型：1-判断题2-单选题3-复选题4-匹配题11-操作题【4暂无】
@property (nonatomic, copy) NSString * part_id; //部分id
@property (nonatomic, copy) NSString * subject_id; //科目id
@property (nonatomic, copy) NSString * attachment; //如果有附件，附件路径
@property (nonatomic, copy) NSString * point; //本题分数
@property (nonatomic, copy) NSArray * question; //题目内容

@property (nonatomic, strong) NSArray * result; //选项内容

@end

@interface AEQuestionSubItem : DateCenter

@property (nonatomic, copy) NSString * type; //类型  text img
@property (nonatomic, copy) NSString * content; //内容

/**
 性能优化 本地使用储存进行下载避免多次加载
 */
@property (nonatomic, strong) UIImage * image;
/**
 GIF图片显示用
 */
@property (nonatomic, strong) NSData * imageData;

/**
 是否是gif
 */
@property (nonatomic, assign) BOOL isGIF;

@end;


//本地记录答案使用
@interface AEResultItem :DateCenter
@property (nonatomic, copy) NSString * answer; //选项内容
@property (nonatomic, assign) BOOL isSelect ; //是否选择 本地使用
@property (nonatomic, assign) NSInteger opation;
@end

@interface AEExamEvaluateSubItem :DateCenter
@property (nonatomic, copy) NSString * part_num; //数量
@property (nonatomic, copy) NSString * part_type; //题目类型
@property (nonatomic, copy) NSString * part_name; //名称
@property (nonatomic, copy) NSString * part_correct; //正确
@property (nonatomic, copy) NSString * part_score; //得分
@property (nonatomic, copy) NSString * part_time; //限时
@end;

@interface AEExamKnowPointItem :DateCenter
@property (nonatomic, copy) NSString * getpoint; //答对数量
@property (nonatomic, copy) NSString * diagnose; //知识点分析
@property (nonatomic, copy) NSString * category; //知识点名称
@property (nonatomic, copy) NSString * point; //知识点考题数量
@end


@interface AEExamEvaluateItem : DateCenter
@property (nonatomic, copy) NSString * total_question; //总共题目数
@property (nonatomic, copy) NSString * exam_time; // 考试时间
@property (nonatomic, copy) NSString * idcard; // 准考证号
@property (nonatomic, copy) NSString * subject_name; // 考卷名称
@property (nonatomic, copy) NSString * total_score; //得分
@property (nonatomic, copy) NSString * paper_score; //总分
@property (nonatomic, copy) NSString * evaluate; //评价
@property (nonatomic, strong) NSArray * part_info;
@property (nonatomic, strong) NSArray * category_info; //知识点明细
@property (nonatomic, copy) NSString * pass; //通过状态
@property (nonatomic, assign) double rate; // z正确率
@end


@interface AEAcaaCategoryItem : DateCenter
@property (nonatomic, copy) NSString  * id;
@property (nonatomic, copy) NSString  * type; //1.acaa 2.adesk
@property (nonatomic, copy) NSString  * name; //显示的section名称
@property (nonatomic, copy) NSString  * create_time;
@property (nonatomic, copy) NSString  * update_time;
@property (nonatomic, strong) NSArray * subject;
/**
 是否关闭展开
 */
@property (nonatomic, assign) BOOL isExpand;

@end




