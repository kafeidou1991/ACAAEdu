//
//  AEPurchaseManage.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,IAPPurchType) {
    kIAPPurchSuccess = 0,       // 购买成功
    kIAPPurchFailed = 1,        // 购买失败
    kIAPPurchCancle = 2,        // 取消购买
    KIAPPurchVerFailed = 3,     // 订单校验失败
    KIAPPurchVerSuccess = 4,    // 订单校验成功  现在给服务器验证 才是正真的购买成功
    kIAPPurchNotArrow = 5,      // 不允许内购
};

typedef void (^IAPCompletionHandle)(IAPPurchType type,NSData *data);

@interface AEPurchaseManage : NSObject
/**
 开始购买
 
 @param orderInfo 产品信息  包含 总价 订单号
 @param handle 回调
 */
- (void)startPurchWithID:(NSDictionary *)orderInfo completeHandle:(IAPCompletionHandle)handle;

@end

