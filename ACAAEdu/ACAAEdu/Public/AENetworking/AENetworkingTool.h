//
//  AERequestTool.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEHttpInfo.h"

typedef void(^RequestSuccessBlock)(id object);
typedef void(^RequestFailureBlock)(NSInteger code,NSString * error);

@interface AENetworkingTool : NSObject

@property (nonatomic, strong) AEHttpInfo * info;
//@property (nonatomic, copy) NSString *mytoken;

/**
 请求方法
 
 @param type HTTP请求类型：GET，POST，PUT，DELETE
 @param methodName 请求方法（ @"/api/user/login"）
 @param query query 可为nil  拼接在url之后的 GET请求
 @param path path 可为nil 请求路径(一般为nil)
 @param body body（NSArray/NSDictionary/NSString）可为nil  请求体
 @param RequestSuccessBlock  成功回调
 @param RequestFailureBlock  失败回调 code码error 错误信息
 */
+ (void)httpRequestAsynHttpType:(HttpRequestType)type
                     methodName:(NSString *)methodName
                     query:(NSMutableDictionary *)query
                     path:(NSString *)path
                     body:(id)body
                     success:(RequestSuccessBlock)success
                     faile:(RequestFailureBlock)faile;



@end
