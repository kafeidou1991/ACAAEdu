//
//  AESetPasswordVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/26.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AESetPasswordVC.h"
#import "AEModifierInfoVC.h"

@interface AESetPasswordVC ()
@property (weak, nonatomic) IBOutlet AETextField *firstTextField;
@property (weak, nonatomic) IBOutlet AETextField *secondTextField;

@end

@implementation AESetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置密码";
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.firstTextField canBecomeFirstResponder]) {
        [self.firstTextField becomeFirstResponder];
    }
    
    self.firstTextField.lengthLimit = self.secondTextField.lengthLimit = 30;
}

- (IBAction)confirmAction:(UIButton *)sender {
    NSString * password = self.firstTextField.text.trimString;
    NSString * rePassword = self.secondTextField.text.trimString;
    
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
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kSetPWD query:nil path:nil body:@{@"password":password,@"repassword":rePassword} success:^(id object) {
        [weakSelf hudclose];
        if (weakSelf.accountType == NoAllAccountType) {
            //进入绑定账户
            AEModifierInfoVC * pushVC = [AEModifierInfoVC new];
            pushVC.type = BindMobileType;
            pushVC.loginData = weakSelf.loginData;
            [weakSelf.navigationController pushViewController:pushVC animated:YES];
        }else {
            [weakSelf loginSuccess];
        }
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
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
