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
typedef void(^RequestFailureBlock)(NSInteger code,id error);

@interface AENetworkingTool : NSObject

@property (nonatomic, strong) AEHttpInfo * info;
//@property (nonatomic, copy) NSString *mytoken;

/**
 请求方法 post请求参数放 body  get请求参数放在query
 
 @param type HTTP请求类型：GET，POST，PUT，DELETE
 @param methodName 请求方法（ @"/api/user/login"）
 @param query query 可为nil  拼接在url之后的 用于GET请求
 @param path path 可为nil 请求路径(一般为nil)
 @param body body（NSArray/NSDictionary/NSString）可为nil  请求体
 @param success  成功回调
 @param faile  失败回调 code码error 错误信息
 */
+ (void)httpRequestAsynHttpType:(HttpRequestType)type
                     methodName:(NSString *)methodName
                     query:(NSMutableDictionary *)query
                     path:(NSString *)path
                     body:(id)body
                     success:(RequestSuccessBlock)success
                     faile:(RequestFailureBlock)faile;





@end
