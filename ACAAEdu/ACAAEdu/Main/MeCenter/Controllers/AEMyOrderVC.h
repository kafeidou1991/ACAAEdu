//
//  AEMyOrderVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/9.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseTableController.h"

typedef NS_ENUM(NSInteger, ExamPayType) {
    ExamNoPayType  = 0,   //未支付
    ExamHasPayType,  //已支付
};

@interface AEMyOrderVC : AEBaseTableController

@property (nonatomic, assign) ExamPayType payType;  //支付模式

@end
