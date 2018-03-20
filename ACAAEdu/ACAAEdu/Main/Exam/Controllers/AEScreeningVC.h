//
//  AEScreeningVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/14.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"

typedef void(^AEScreeningResultBlock)(NSDictionary *);

@interface AEScreeningVC : AEBaseController

@property (nonatomic, copy) AEScreeningResultBlock resultBlock;

@end
