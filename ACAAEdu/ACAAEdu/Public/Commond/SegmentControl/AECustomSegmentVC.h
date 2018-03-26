//
//  AESegmentControl.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/26.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"

@interface AECustomSegmentVC : AEBaseController

- (void)setupPageView:(NSArray <NSString *> *)titlesArray ContentViewControllers:(NSArray <UIViewController *> * )viewControllers;

@end
