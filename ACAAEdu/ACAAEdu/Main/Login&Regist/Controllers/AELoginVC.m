//
//  ACLoginVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/25.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AELoginVC.h"
#import "AENavigationController.h"
#import "AEForgetPwVC.h"
#import "AERegistNewVC.h"
#import "AEModifierInfoVC.h"

@interface AELoginVC ()<UITextFieldDelegate,UINavigationControllerDelegate>
/**
 账号框
 */
@property (weak, nonatomic) IBOutlet AETextField *accountTextField;
/**
 密码框
 */
@property (weak, nonatomic) IBOutlet AETextField *passwordTextField;
/**
 密码背景
 */
@property (weak, nonatomic) IBOutlet UIView *pwdBgView;
/**
 账户背景
 */
@property (weak, nonatomic) IBOutlet UIView *accountBgView;
/**
 登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;



@end

@implementation AELoginVC

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"登录";
    self.navigationController.delegate = self;
    [self initComonpent];
    
}
- (void)initComonpent {
    self.pwdBgView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    self.accountBgView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    
    self.accountTextField.text = [AEUserDefaults objectForKey:@"ACAA_MobileAcount"];
}

#pragma mark - 忘记密码 登录 注册
- (IBAction)loginClick:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString * account = self.accountTextField.text.trimString;
    NSString * password = self.passwordTextField.text.trimString;
    if (!account.isValidateMobile && !account.isValidateEmail) {
        [AEBase alertMessage:@"请输入正确的手机号/邮箱!" cb:nil];
        return;
    }
    if (password.length < 6) {
        [AEBase alertMessage:@"请输入6-30位的密码!" cb:nil];
        return;
    }
    //登录成功
    WS(weakSelf);
//    18511032576  123456
    NSDictionary * paramsDic = @{ @"username":account,
                                  @"password":password,
                                  @"scene":@"acount"};
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kLogin query:paramsDic.mutableCopy path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        [AEUserDefaults setObject:account forKey:@"ACAA_MobileAcount"];
        [weakSelf loginSuccess:object];
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
    AEForgetPwVC * vc = [AEForgetPwVC new];
    PUSHCustomViewController(vc, self);
}

- (IBAction)registClick:(id)sender {
    [self.view endEditing:YES];
    PUSHCustomViewController([AERegistNewVC new], self);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString * account,* pwd;
    if (textField.tag == 100) {
        account = str;
        pwd = [(AETextField *)[self.view viewWithTag:101] text];
    }else {
        pwd = str;
        account = [(AETextField *)[self.view viewWithTag:100] text];
    }
    if ((pwd.length >= 6) & ([account containsString:@"@"] || account.length == 11)) {
        self.loginBtn.enabled = YES;
        self.loginBtn.alpha = 1;
    }else {
        self.loginBtn.enabled = YES;
        self.loginBtn.alpha = 0.5;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - 触发响应者
- (IBAction)pwdBgClickAction:(UITapGestureRecognizer *)sender {
    if ([self.passwordTextField canBecomeFirstResponder]) {
        [self.passwordTextField becomeFirstResponder];
    }
}
- (IBAction)accountBgClickAction:(UITapGestureRecognizer *)sender {
    if ([self.accountTextField canBecomeFirstResponder]) {
        [self.accountTextField becomeFirstResponder];
    }
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
- (IBAction)backAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShow = [viewController isKindOfClass:[self class]];
    [navigationController setNavigationBarHidden:isShow animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



@end
