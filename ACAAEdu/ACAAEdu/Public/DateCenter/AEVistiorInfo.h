//
//  AEVistiorInfo.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2019/1/29.
//  Copyright © 2019 ACAA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LoginCompliont)(void);
@class AEBaseController;
@interface AEVistiorInfo : NSObject
/** 该类是为了判断游客模式下的一些逻辑判断
 * 游客模式下登录逻辑，目前做的就是在游客模式下采用（15837219106 123456 ）默认apple的游客账户，为了apple check时用。正常逻辑下是没有这种模式，不去检测。
 * 切记：审核的时候需要通知服务器将kUserProfile接口的version（返回当前审核版本）、isShow配置为YES，过审之后配置为NO即可，否则后果自负。
 * 因为苹果 check都是用的本地同一个账号进行假登录，所以提交审核之前应该清空所购买的考试，避免产生错误的试卷（没有购买就生成）
 */
+ (instancetype)shareInstance;
/**
 当前版本号
 */
@property (nonatomic, copy) NSString * version;
/**
 是否显示
 */
@property (nonatomic, assign) BOOL isShow;

/**
 游客模式是否登录，每次重启需要重新登录
 */
@property (nonatomic, assign) BOOL isLogin;


/**
 游客模式下选择登录方式

 @param compliont 登录完成回调
 */
- (void)alertLoginType:(AEBaseController *)viewController Compliont:(LoginCompliont)compliont;

/**
 此处是为了审核的游客模式下进行购买操作，紧紧是为了审核用，切勿做其他操作。避免审核出现问题
 */
- (void)visitorLogin:(BOOL)isLoad;


@end

NS_ASSUME_NONNULL_END
