//
//  AECheckIdCardVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/26.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AERegistIdCardVC.h"

@interface AERegistIdCardVC ()
@property (weak, nonatomic) IBOutlet AETextField *idCardTextField;
@property (weak, nonatomic) IBOutlet AETextField *nameTextField;

@end

@implementation AERegistIdCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"绑定身份证";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [AEBase createCustomBarButtonItem:self action:@selector(skip) title:@"跳过"];
}
//跳过
- (void)skip {
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kRegisterCreate query:nil path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        [AEBase alertMessage:@"注册成功" cb:nil];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
    
}
//MARK: 绑定
- (IBAction)bindClick:(UIButton *)sender {
    NSString * idCard = self.idCardTextField.text.trimString;
    NSString * name =self.nameTextField.text.trimString;
    if (![idCard validateIdentityCard]) {
        [AEBase alertMessage:@"身份证格式错误" cb:nil];
        return;
    }
    if (STRISEMPTY(name)) {
        [AEBase alertMessage:@"请输入真实姓名" cb:nil];
        return;
    }
    
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kRegisterBindIdCard query:nil path:nil body:@{@"id_card":idCard,@"user_name":name} success:^(id object) {
        [weakSelf hudclose];
        [AEBase alertMessage:@"绑定成功" cb:nil];
       [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
    
}


@end