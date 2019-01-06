//
//  AEOrderDetailVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"

typedef NS_ENUM(NSInteger, AEOrderPayStatus) {
    AEOrderPayingStatus = 0, //未支付
    AEOrderPaidStatus, //已支付
    AEOrderAffirmPay, //确认订单
};

typedef NS_ENUM(NSInteger, ComeFromType) {
    ComeFromMyNormalType = 0,  //页面来源  返回rootVC
    ComeFromMyOrderType,       //我的订单页面
};


@class AEExamItem;
@interface AEOrderDetailVC : AEBaseController

@property (nonatomic, strong) AEExamItem *item;
@property (nonatomic, assign) ComeFromType comeType; //页面来源
/**
 订单状态 默认待支付
 */
@property (nonatomic, assign) AEOrderPayStatus payStatus;


@end
