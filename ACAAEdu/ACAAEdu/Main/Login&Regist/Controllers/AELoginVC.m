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
#import "AERegistNewVC.h"
#import "AESetPasswordVC.h"
#import "AEModifierInfoVC.h"

typedef NS_ENUM(NSInteger, LoginType) {
    AccountLoginType = 100,
    CardLoginType,
};

@interface AELoginVC ()<UITextFieldDelegate>
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
    self.accountTextField.text = [AEUserDefaults objectForKey:@"ACAA_MobileAcount"];
    
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
    NSDictionary * paramsDic = @{(self.loginType == AccountLoginType ? @"username" : @"id_card"):account,
                                 (self.loginType == AccountLoginType ? @"password" : @"user_name"):password,
                                 @"scene":(self.loginType == AccountLoginType ? @"acount" : @"idCard")};
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kLogin query:nil path:nil body:paramsDic success:^(id object) {
        [weakSelf hudclose];
        if (self.loginType == AccountLoginType) {
            [AEUserDefaults setObject:account forKey:@"ACAA_MobileAcount"];
            [weakSelf loginSuccess:object];
        }else {
            //身份证登录 没有设置密码 设置密码，没有账号设置账号  只有账号跟密码全部设置才能登录成功
            //account_status: 0=>正常 1=>没有账号且没有密码 2=>没有设置(无手机号且无邮箱) 账号 3=>没有设置密码
            NSInteger  accountStatus = [object[@"account_status"]integerValue];
            if (accountStatus == 0) {
//                [weakSelf loginSuccess:object];
                [AEBase alertMessage:@"已经绑定手机/邮箱,请使用账户登陆" cb:nil];
            }else if (accountStatus == 2) {
                //进入绑定账户
                AEModifierInfoVC * pushVC = [AEModifierInfoVC new];
                pushVC.type = BindMobileType;
                pushVC.loginData = object;
                [weakSelf.navigationController pushViewController:pushVC animated:YES];
            }else {
                AESetPasswordVC * pushVC = [AESetPasswordVC new];
                pushVC.loginData = object;
                pushVC.accountType = accountStatus;
                PUSHCustomViewController(pushVC, weakSelf);
            }
        }
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
        if (self.loginCompletion) {
            self.loginCompletion(NO);
        }
    }];
}
- (void)loginSuccess:(id)object {
    if (object) {
        [AEUserInfo yy_modelWithDictionary:object];
        [User save];
    }
    if (self.loginCompletion) {
        self.loginCompletion(YES);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSuccess object:nil];
    [self backAction:nil];
}
- (IBAction)forgetClick:(UIButton *)sender {
    [self.view endEditing:YES];
    AERegistVC * vc = [AERegistVC new];
    vc.isFindPassword = YES;
    PUSHCustomViewController(vc, self);
}

- (IBAction)registClick:(id)sender {
    [self.view endEditing:YES];
    PUSHCustomViewController([AERegistNewVC new], self);
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
//    self.accountTextField.keyboardType = b ? UIKeyboardTypeDefault:UIKeyboardTypePhonePad;
    self.accountTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.accountTextField.lengthLimit = b ? 18 : 40;
    self.accountTextField.placeholder = b ? @"请输入身份证号" : @"请输入手机号/邮箱";
    self.accountTextField.text =@"";
    self.passwordTextField.secureTextEntry = !b;
    self.passwordTextField.lengthLimit = 30;
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - other
//吊起登录
+(void) OpenLogin:(UIViewController *)viewController callback:(CBLoginCompletion) loginComplation {
    AELoginVC *loginv = [[AELoginVC alloc] init];
    if (loginComplation) {
        loginv.loginCompletion = loginComplation;
    }
    AENavigationController *nav = [[AENavigationController alloc]initWithRootViewController:loginv];
    // 问题：模态的时候有延迟，而且延迟比较厉害。第一次遇到这种问题；上网查了一下，网上给出的答案：由于某种原因： presentViewController:animated:completion 里的内容并不会真的马上触发执行，除非有一个主线程事件触发。比如在弹出慢的时候，你随便点击一下屏幕，马上就能弹出来；这个我亲自测试了是这种情况
    // 解决方法：将 presentViewController:animated:completion: 添加到主线程
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [viewController presentViewController:nav animated:YES completion:nil];
    }];
}
//返回
- (void)backAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
