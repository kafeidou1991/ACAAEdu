//
//  AEModifierInfoVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/23.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEModifierInfoVC.h"
#import "CircularProgressBar.h"

@interface AEModifierInfoVC ()<CircularProgressDelegate>
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
 绑定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@end

@implementation AEModifierInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initComonpent];
    
}

- (void)initComonpent {
    if (self.type == BindEmailType) {
        self.title = @"绑定邮箱";
        [self.bindBtn setTitle:@"确定绑定" forState:UIControlStateNormal];
    }
    self.circularBar.delegate =self;
    [self changeTextFieldStatus];
}
- (void)changeTextFieldStatus {
    //身份证18位 手机号11位 邮箱40
    if (self.type == BindEmailType) {
        self.accountTextField.lengthLimit = 40;
        self.accountTextField.placeholder = @"请输入邮箱";
    }
    if ([self.accountTextField canBecomeFirstResponder]) {
        [self.accountTextField becomeFirstResponder];
    }
}
-(void)afterProFun {
    //获取图形验证码
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:@"mobile/user/captcha" query:nil path:nil body:nil success:^(id object) {
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
#pragma mark - 解绑，绑定
- (IBAction)bindClick:(UIButton *)sender {
    NSString * account = self.accountTextField.text.trimString;
    NSString * imageCode = self.imageTextField.text.trimString;
    NSString * code = self.codeTextField.text.trimString;
    if (self.type == BindEmailType) {
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
    //注册
    NSMutableDictionary * pramsDict = @{}.mutableCopy;
    [pramsDict setObject:account forKey:@"email"];
    [pramsDict setObject:code forKey:@"verify"];
    NSLog(@"%@",pramsDict);
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:@"mobile/user/bindEmail" query:nil path:nil body:pramsDict success:^(id object) {
        [weakSelf hudclose];
        [AEBase alertMessage:@"绑定成功!" cb:nil];
        //        if (weakSelf.presentingViewController.presentingViewController) {
        //            [weakSelf.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        //        }else {
        //            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        //        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
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
    if (self.type == BindEmailType) {
        if (!account.isValidateEmail) {
            [AEBase alertMessage:@"请输入正确邮箱!" cb:nil];
            return;
        }
    }
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:@"mobile/user/verify" query:nil path:nil body:@{@"captcha":imageCode,@"account":account} success:^(id object) {
        [weakSelf hudclose];
        [AEBase alertMessage:@"验证码已发送..." cb:nil];
        [weakSelf circleProgressStart];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
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

@end