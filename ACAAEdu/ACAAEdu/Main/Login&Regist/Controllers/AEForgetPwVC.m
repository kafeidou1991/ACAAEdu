//
//  AEForgetPwVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/7.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEForgetPwVC.h"
#import "CircularProgressBar.h"

typedef NS_ENUM(NSInteger, RegistType) {
    MobileRegistType = 100,
    EmileRegistType,
};


@interface AEForgetPwVC ()<CircularProgressDelegate,UITextFieldDelegate>
/**
注册方式
 */
@property (nonatomic, assign) RegistType registType;
/**
 顶部手机按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mobileButton;
/**
 顶部邮箱按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
/**
 底部横线左约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstrain;
/**
 账号提示文案
 */
@property (weak, nonatomic) IBOutlet UILabel *accountTipLabel;
/**
 账号输入框
 */
@property (weak, nonatomic) IBOutlet AETextField *accountTextField;
/**
 图形验证码输入框
 */
@property (weak, nonatomic) IBOutlet AETextField *imageTextField;
/**
  图形验证码图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
/**
 验证码输入框
 */
@property (weak, nonatomic) IBOutlet AETextField *codeTextField;
/**
 获取验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
/**
 倒计时圈
 */
@property (weak, nonatomic) IBOutlet CircularProgressBar *circularBar;
/**
 密码框
 */
@property (weak, nonatomic) IBOutlet AETextField *passwordTextField;
/**
 底部button
 */
@property (weak, nonatomic) IBOutlet UIButton *bttomButton;

@end

@implementation AEForgetPwVC

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self initComonpent];
    
}
- (void)initComonpent {
    self.registType = MobileRegistType;
    self.circularBar.delegate =self;
    [self changeTextFieldStatus];
}
-(void)afterProFun {
    //获取图形验证码
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kCaptcha query:nil path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        [weakSelf.codeImageView sd_setImageWithURL:[NSURL URLWithString:object[@"imgUrl"]]];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
//重新发送图形验证码
- (IBAction)reSendImageCodeClick:(UITapGestureRecognizer *)sender {
    [self afterProFun];
}

#pragma mark - 注册
- (IBAction)registClick:(UIButton *)sender {
    NSString * account = self.accountTextField.text.trimString;
    NSString * imageCode = self.imageTextField.text.trimString;
    NSString * code = self.codeTextField.text.trimString;
    NSString * password = self.passwordTextField.text.trimString;
    if (self.registType == MobileRegistType) {
        if (!account.isValidateMobile) {
            [AEBase alertMessage:@"请输入正确的手机号!" cb:nil];
            return;
        }
    }else {
        if (!account.isValidateEmail) {
            [AEBase alertMessage:@"请输入正确邮箱!" cb:nil];
            return;
        }
    }
    if (imageCode.length <= 0) {
        [AEBase alertMessage:@"请输入正确的图形验证码!" cb:nil];
        return;
    }
    if (code.length <= 0) {
        [AEBase alertMessage:@"请输入正确的验证码!" cb:nil];
        return;
    }
    if (password.length < 6 || password.length > 30) {
        [AEBase alertMessage:@"请输入6-30位的密码!" cb:nil];
        return;
    }
    //注册
    NSMutableDictionary * pramsDict = @{}.mutableCopy;
    [pramsDict setObject:account forKey:(self.registType == MobileRegistType) ? @"mobile" : @"email"];
    [pramsDict setObject:password forKey:@"password"];
    [pramsDict setObject:code forKey:@"verify"];
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kFindPassword query:nil path:nil body:pramsDict success:^(id object) {
        [weakSelf hudclose];
        [AEBase alertMessage:@"密码已重置" cb:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
#pragma mark - 发送验证码
- (IBAction)sendCodeClick:(UIButton *)sender {
    NSString * account = self.accountTextField.text.trimString;
    NSString * imageCode = self.imageTextField.text.trimString;
    if (imageCode.length <= 0) {
        [AEBase alertMessage:@"请输入图形验证码!" cb:nil];
        return;
    }
    if (self.registType == MobileRegistType) {
        if (!account.isValidateMobile) {
            [AEBase alertMessage:@"请输入正确的手机号!" cb:nil];
            return;
        }
    }else {
        if (!account.isValidateEmail) {
            [AEBase alertMessage:@"请输入正确邮箱!" cb:nil];
            return;
        }
    }
    
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kVerifyCode query:nil path:nil body:@{@"captcha":imageCode,@"account":account} success:^(id object) {
        [weakSelf hudclose];
        [AEBase alertMessage:@"验证码已发送..." cb:nil];
        [weakSelf circleProgressStart];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
#pragma mark - 切换注册方式
- (IBAction)changeRegistClick:(UIButton *)sender {
    //选择相同的item直接返回不做处理
    if (self.registType == sender.tag) {
        return;
    }
    self.registType = sender.tag;
    [self changeButtonStatus];
    [self changeTextFieldStatus];
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
- (void)changeTextFieldStatus {
    BOOL b = self.registType - 100;
    //身份证18位 手机号11位
    self.accountTextField.lengthLimit = b ? 40 : 11;
    self.accountTipLabel.text = b ? @"请输入邮箱" : @"请输入手机号";
    self.accountTextField.text =@"";
    if ([self.accountTextField canBecomeFirstResponder]) {
        [self.accountTextField becomeFirstResponder];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - 进度条
// 开启圆形进度条
- (void)circleProgressStart {
    self.sendCodeBtn.hidden = YES;
    self.circularBar.hidden = NO;
    [self.circularBar setTotalSecondTime:60];
    [self.circularBar startTimer];
}
- (void)CircularProgressEnd {
    self.sendCodeBtn.hidden = NO;
    self.circularBar.hidden = YES;
    
    [self.sendCodeBtn wy_animate];
    [self.circularBar wy_animate];
    
}

//返回
- (void)backAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)click1:(id)sender {
    if ([self.accountTextField canBecomeFirstResponder]) {
        [self.accountTextField becomeFirstResponder];
    }
}
- (IBAction)click2:(id)sender {
    if ([self.imageTextField canBecomeFirstResponder]) {
        [self.imageTextField becomeFirstResponder];
    }
}
- (IBAction)click3:(id)sender {
    if ([self.codeTextField canBecomeFirstResponder]) {
        [self.codeTextField becomeFirstResponder];
    }
}
- (IBAction)click4:(id)sender {
    if ([self.passwordTextField canBecomeFirstResponder]) {
        [self.passwordTextField becomeFirstResponder];
    }
}



@end
