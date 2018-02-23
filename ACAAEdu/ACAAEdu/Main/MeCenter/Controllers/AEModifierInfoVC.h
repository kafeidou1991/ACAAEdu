//
//  AEModifierInfoVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/23.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseTableController.h"

typedef NS_ENUM(NSInteger, ModifierType) {
    BindEmailType = 0,  //绑定邮箱
    BindMobileType, //绑定手机号
    BindMobileIdCardType, //绑定身份证
    UnBindEmailType,  //解绑邮箱
    UnBindMobileType, //解绑手机号
    UnBindMobileIdCardType //解绑身份证
};

@interface AEModifierInfoVC : AEBaseTableController

@property (nonatomic, assign) ModifierType type;


@end
