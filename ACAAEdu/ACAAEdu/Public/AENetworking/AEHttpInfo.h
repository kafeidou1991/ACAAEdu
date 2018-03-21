//
//  AEHttpInfo.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <Foundation/Foundation.h>

// MARK: -----切换环境key-----
#define ChangeServerEnv @"ChangeServerEnv"

typedef NS_ENUM(NSUInteger, HttpRequestType) {
    HttpRequestTypeGET = 0,
    HttpRequestTypePOST,
    HttpRequestTypePUT,
    HttpRequestTypeDELETE,
};


@interface AEHttpInfo : NSObject

@property (nonatomic, copy) NSString *networkDomain;    //域名
@property (nonatomic, copy) NSString *methodName;           //方法名
@property (nonatomic, copy) NSString *urlPath;          //path值
@property (nonatomic, copy) NSString *apiSign;          //数字签名
@property (nonatomic, copy) NSString *apiToken;         //用户token
@property (nonatomic, copy) NSString *platform;         //平台
@property (nonatomic, copy) NSString *timestamp;        //时间戳
@property (nonatomic, copy) NSDictionary *query;        //query参数
@property (nonatomic, assign) HttpRequestType httpType;        //请求方式
@property (nonatomic, copy) id body;                    //请求body体
@property (nonatomic, strong) id item;
@end
