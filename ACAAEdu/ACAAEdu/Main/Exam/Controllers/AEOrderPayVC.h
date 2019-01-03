//
//  AEOrderPayVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/13.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"
#import "AEOrderDetailVC.h"

@interface AEOrderPayVC : AEBaseController

@property (nonatomic, strong) AEMyOrderList * item; //订单信息

@property (nonatomic, assign) CGFloat totalPrice; //商品价格

@property (nonatomic, assign) ComeFromType comeType; //页面来源
@end
