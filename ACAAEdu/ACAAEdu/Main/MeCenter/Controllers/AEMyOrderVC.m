//
//  AEMyOrderVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/9.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyOrderVC.h"

@interface AEMyOrderVC ()

@end

@implementation AEMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    [self createTableViewStyle:UITableViewStylePlain];
    
}

-(void)afterProFun {
    WS(weakSelf);
//    18516981076
    [self hudShow:self.view msg:STTR_ater_on];
//    @{@"pay_status":@"1",@"lastid":@"0"}
//    mobile/subject_category/index
//    kOrderList
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kOrderList query:nil path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        NSLog(@"%@",object);
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}



@end
