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
};

@interface AEModifierInfoVC : AEBaseTableController

@property (nonatomic, assign) ModifierType type;


@end
