//
//  AESetPasswordVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/26.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"
//account_status: 0=>正常 1=>没有账号且没有密码 2=>没有设置(无手机号且无邮箱) 账号 3=>没有设置密码
typedef NS_ENUM(NSInteger, AccountSetpwdType){
    NoAllAccountType = 1,
    NoMobileAccountType = 2,  //绑定账号其他页面处理
    NopasswordAccountType = 3
};


@interface AESetPasswordVC : AEBaseController

@property (nonatomic, assign) AccountSetpwdType accountType;

@property (nonatomic, strong) id loginData;

@end
