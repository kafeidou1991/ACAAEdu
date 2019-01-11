//
//  AESetNickNamePwVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/10/25.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AESetNickNamePwVC.h"

@interface AESetNickNamePwVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet AETextField *firstTextField;
@property (weak, nonatomic) IBOutlet AETextField *secondTextField;
@property (weak, nonatomic) IBOutlet AETextField *nickNameField;

@end

@implementation AESetNickNamePwVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置昵称和密码";
    self.firstTextField.lengthLimit = self.secondTextField.lengthLimit = 30;
    
    
}
- (IBAction)confirmAction:(UIButton *)sender {
    NSString * password = self.firstTextField.text.trimString;
    NSString * rePassword = self.secondTextField.text.trimString;
    NSString * nickName = self.nickNameField.text.trimString;
    
    if (password.length < 6 || rePassword.length < 6) {
        [AEBase alertMessage:@"请输入6-30位的密码!" cb:nil];
        return;
    }
    if (![password isEqualToString:rePassword]) {
        [AEBase alertMessage:@"两次密码输入不一致!" cb:nil];
        return;
    }
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    NSDictionary * paramDict;
    if (STRISEMPTY(nickName)) {
        paramDict = @{@"password":password,@"repassword":rePassword};
    }else {
        paramDict = @{@"username":nickName,@"password":password,@"repassword":rePassword};
    }
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kRegisterPWD query:nil path:nil body:paramDict success:^(id object) {
        [weakSelf loginSuccess];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)loginSuccess {
    if (!STRISEMPTY(self.account)) {
        [AEUserDefaults setObject:self.account forKey:@"ACAA_MobileAcount"];
    }
    //确认注册
    [self requestRegister];
}
- (void)requestRegister {
    WS(weakSelf);
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kRegisterCreate query:nil path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        [AEBase alertMessage:@"注册成功" cb:nil];
        //设置完密码昵称 跳转登录页面 登录
        [weakSelf.navigationController pushViewController:[AELoginVC new] animated:YES];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
