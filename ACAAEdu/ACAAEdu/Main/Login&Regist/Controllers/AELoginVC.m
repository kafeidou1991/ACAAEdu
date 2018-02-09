//
//  ACLoginVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/25.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AELoginVC.h"
#import "AENavigationController.h"
#import "AERegistVC.h"

typedef NS_ENUM(NSInteger, LoginType) {
    AccountLoginType = 100,
    CardLoginType,
};

@interface AELoginVC ()
/**
 登录方式
 */
@property (nonatomic, assign) LoginType loginType;
/**
 底部横线左约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstrain;
@property (weak, nonatomic) IBOutlet AETextField *accountTextField;
@property (weak, nonatomic) IBOutlet AETextField *passwordTextField;

@end

@implementation AELoginVC

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =@"登录";
    [self initComonpent];
    
}
- (void)initComonpent {
    self.loginType = AccountLoginType;
    [self changeTextFieldStatus];
}
#pragma mark - 忘记密码 登录 注册
- (IBAction)loginClick:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString * account = self.accountTextField.text.trimString;
    NSString * password = self.passwordTextField.text.trimString;
    if (self.loginType == AccountLoginType) {
        if (!account.isValidateMobile && !account.isValidateEmail) {
            [AEBase alertMessage:@"请输入正确的手机号/邮箱!" cb:nil];
            return;
        }
        if (password.length < 6) {
            [AEBase alertMessage:@"请输入6-30位的密码!" cb:nil];
            return;
        }
    }else {
        if (!account.validateIdentityCard) {
            [AEBase alertMessage:@"请输入正确的身份证号码!" cb:nil];
            return;
        }
        if (password.length <=0) {
            [AEBase alertMessage:@"请输入正确的姓名!" cb:nil];
            return;
        }
    }
    //登录成功
    WS(weakSelf);
//    18511032576  123456
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kLoginAPI query:nil path:nil body:@{@"username":account,@"password":password,@"scene":(self.loginType == AccountLoginType ? @"acount" : @"idCard")} success:^(id object) {
        [weakSelf hudclose];
        NSLog(@"-----%@",object);
        if (object) {
           [AEUserInfo yy_modelWithDictionary:object];
            [User save];
        }
        if (weakSelf.loginCompletion) {
            weakSelf.loginCompletion(YES);
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSuccess object:nil];
        [weakSelf backAction:nil];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
        if (self.loginCompletion) {
            self.loginCompletion(NO);
        }
    }];
}
- (IBAction)forgetClick:(UIButton *)sender {
    [self.view endEditing:YES];
}

- (IBAction)registClick:(id)sender {
    [self.view endEditing:YES];
    AENavigationController *nav = [[AENavigationController alloc]initWithRootViewController:[AERegistVC new]];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 切换登录方式
- (IBAction)changeLoginClick:(UIButton *)sender {
    //选择相同的item直接返回不做处理
    if (self.loginType == sender.tag) {
        return;
    }
    self.loginType = sender.tag;
    [self changeButtonStatus];
    [self changeTextFieldStatus];
}

- (void)changeTextFieldStatus {
    BOOL b = self.loginType - 100;
    //身份证18位 手机号11位
    self.accountTextField.lengthLimit = b ? 18 : 11;
    self.accountTextField.placeholder = b ? @"请输入身份证号" : @"请输入手机号/邮箱";
    self.accountTextField.text =@"";
    self.passwordTextField.secureTextEntry = !b;
    self.passwordTextField.lengthLimit = 30;
    self.passwordTextField.keyboardType = b ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
    self.passwordTextField.placeholder = b ? @"请输入姓名" : @"请输入密码";
    self.passwordTextField.text =@"";
    if ([self.accountTextField canBecomeFirstResponder]) {
        [self.accountTextField becomeFirstResponder];
    }
}
- (void)changeButtonStatus {
    UIButton * accountBtn = [self.view viewWithTag:100];
    UIButton * cardBtn = [self.view viewWithTag:101];
    accountBtn.selected = !accountBtn.selected;
    cardBtn.selected = !cardBtn.selected;
    self.bottomViewConstrain.constant = accountBtn.isSelected ? 0 : cardBtn.x;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)click {
    [AEUserInfo yy_modelWithDictionary:@{@"user_id":@"11"}];
    [User save];
    NSLog(@"-----");
}
- (void)click1 {
    NSLog(@"%d",User.isLogin);
}
- (void)click2 {
    [User removeLoginData];
    NSLog(@"%d",User.isLogin);
    NSLog(@"%@",User);
}
#pragma mark - other
//吊起登录
+(void) OpenLogin:(UIViewController *)viewController callback:(CBLoginCompletion) loginComplation {
    AELoginVC *loginv = [[AELoginVC alloc] init];
    if (loginComplation) {
        loginv.loginCompletion = loginComplation;
    }
    AENavigationController *nav = [[AENavigationController alloc]initWithRootViewController:loginv];;
    [viewController presentViewController:nav animated:YES completion:nil];
}
//返回
-(void)backAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
