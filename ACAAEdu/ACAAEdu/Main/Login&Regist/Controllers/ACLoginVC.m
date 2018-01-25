//
//  ACLoginVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/25.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "ACLoginVC.h"

@interface ACLoginVC ()

@end

@implementation ACLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor whiteColor];
    btn1.frame = CGRectMake(100, 300, 100, 100);
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.frame = CGRectMake(100, 500, 100, 100);
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
}
- (void)click {
    [AEUserInfo yy_modelWithDictionary:@{@"user_id":@"11"}];
    [User save];
    NSLog(@"-----");
}
- (void)click1 {
    NSLog(@"%d",User.isLogin);
    NSLog(@"%@",User.user_id);
}
- (void)click2 {
    [User removeLoginData];
    NSLog(@"%d",User.isLogin);
    NSLog(@"%@",User);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
