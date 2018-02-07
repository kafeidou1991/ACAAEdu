//
//  ACLoginVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/25.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"

typedef void (^CBLoginCompletion)(BOOL compliont);

@interface AELoginVC : AEBaseController


@property(nonatomic,copy) CBLoginCompletion loginCompletion;

+(void) OpenLogin:(UIViewController *)viewController callback:(CBLoginCompletion) loginComplation;

@end
