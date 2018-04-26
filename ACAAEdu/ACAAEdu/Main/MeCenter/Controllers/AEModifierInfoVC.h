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
    UnBindEmailType,  //解绑邮箱
    UnBindMobileType, //解绑手机号
};

@interface AEModifierInfoVC : AEBaseTableController

@property (nonatomic, assign) ModifierType type;


/**
 为了增加标识是否从登陆绑定手机而来
 */
@property (nonatomic, strong) id loginData;

@end
