//
//  AEExamResultVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/31.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamResultVC.h"

@interface AEExamResultVC ()

@end

@implementation AEExamResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成绩单";
    
    //            for (UIViewController *viewController in self.navigationController.viewControllers) {
    //                if ([viewController isKindOfClass:[NewCourseViewController class]] ||[viewController isKindOfClass:[CourseTestViewController class]] ||[viewController isKindOfClass:[MytestViewController class]]) {
    //                    [self.navigationController popToViewController:viewController animated:YES];
    //                }
    //            }
    
}
-(void)afterProFun {
    WS(weakSelf);
    //获取评价
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kExamEvaluate query:nil path:nil body:@{@"exam_id":self.examId} success:^(id object) {
        [weakSelf hudclose];
        
        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}


@end
