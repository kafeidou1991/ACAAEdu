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
@property (nonatomic, strong) PageItem * page;//分页使用
@end

@interface PageItem : NSObject
@property (nonatomic, copy) NSString * pageSize;
@property (nonatomic, copy) NSString * pageNo;//页数
@property (nonatomic, copy) NSString * lastIndex;
@property (nonatomic, copy) NSString * firstIndex;
@property (nonatomic, copy) NSString * pageCount;
@property (nonatomic, copy) NSString * lastPage;//是否是最后一页
@property (nonatomic, copy) NSString * firstPage;
@property (nonatomic, copy) NSString * resultCount;
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













