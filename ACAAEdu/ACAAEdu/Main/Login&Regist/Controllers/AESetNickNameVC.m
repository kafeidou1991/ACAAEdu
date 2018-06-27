//
//  AESetNickNameVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/6/20.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AESetNickNameVC.h"
#import "AERegistIdCardVC.h"

@interface AESetNickNameVC ()

@property (weak, nonatomic) IBOutlet AETextField *nickNameField;
@property (weak, nonatomic) IBOutlet AETextField *firstTextField;
@property (weak, nonatomic) IBOutlet AETextField *secondTextField;

@end

@implementation AESetNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置昵称和密码";
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.nickNameField canBecomeFirstResponder]) {
        [self.nickNameField becomeFirstResponder];
    }
    self.firstTextField.lengthLimit = self.secondTextField.lengthLimit = 30;
}
//MARK: 提交
- (IBAction)confirmAction:(UIButton *)sender {
    NSString * nickName = self.nickNameField.text.trimString;
    NSString * password = self.firstTextField.text.trimString;
    NSString * rePassword = self.secondTextField.text.trimString;
    if (STRISEMPTY(nickName)) {
        [AEBase alertMessage:@"请输入昵称!" cb:nil];
        return;
    }
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
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kRegisterPWD query:nil path:nil body:@{@"username":nickName,@"password":password,@"repassword":rePassword} success:^(id object) {
        [weakSelf hudclose];
        [weakSelf.navigationController pushViewController:[AERegistIdCardVC new] animated:YES];
        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
