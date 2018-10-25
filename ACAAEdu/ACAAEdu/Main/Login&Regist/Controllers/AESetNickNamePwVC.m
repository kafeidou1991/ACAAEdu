//
//  AESetNickNamePwVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/10/25.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AESetNickNamePwVC.h"

@interface AESetNickNamePwVC ()

@property (weak, nonatomic) IBOutlet AETextField *firstTextField;
@property (weak, nonatomic) IBOutlet AETextField *secondTextField;
@property (weak, nonatomic) IBOutlet AETextField *nickNameField;

@end

@implementation AESetNickNamePwVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置昵称和密码";
    if ([self.firstTextField canBecomeFirstResponder]) {
        [self.firstTextField becomeFirstResponder];
    }
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
    if (STRISEMPTY(nickName)) {
        [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kSetPWD query:nil path:nil body:@{@"password":password,@"repassword":rePassword} success:^(id object) {
            [weakSelf hudclose];
            [weakSelf loginSuccess];
        } faile:^(NSInteger code, NSString *error) {
            [weakSelf hudclose];
            [AEBase alertMessage:error cb:nil];
        }];
    }else {
        [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kRegisterPWD query:nil path:nil body:@{@"username":nickName,@"password":password,@"repassword":rePassword} success:^(id object) {
            [weakSelf hudclose];
            [weakSelf loginSuccess];
        } faile:^(NSInteger code, NSString *error) {
            [weakSelf hudclose];
            [AEBase alertMessage:error cb:nil];
        }];
    }
}

- (void)loginSuccess {
    if (self.loginData) {
        [AEUserInfo yy_modelWithDictionary:self.loginData];
        [User save];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSuccess object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
