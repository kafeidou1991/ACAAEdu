//
//  HomePageVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "HomePageVC.h"

@interface HomePageVC ()

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:@"api/user/login" query:nil path:nil body:@{@"username":@"18511032576",@"password":@"123456",@"scene":@"acount"} success:^(id object) {
        NSLog(@"-----%@",object);
    } faile:^(NSInteger code, NSString *error) {
        NSLog(@"code---%ld,error--%@",code,error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
