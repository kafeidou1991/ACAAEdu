//
//  AERegistNewVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/6/20.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AERegistNewVC.h"
#import "CircularProgressBar.h"
#import "AESetNickNamePwVC.h"

@interface AERegistNewVC ()<CircularProgressDelegate>
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
 获取验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
/**
 验证码输入框
 */
@property (weak, nonatomic) IBOutlet AETextField *codeTextField;
/**
 倒计时圈
 */
@property (weak, nonatomic) IBOutlet CircularProgressBar *circularBar;
/**
 底部button
 */
@property (weak, nonatomic) IBOutlet UIButton *bttomButton;


@end

@implementation AERegistNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComonpent];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册账号";
    
}
- (void)initComonpent {
    self.circularBar.delegate =self;
    [self changeTextFieldStatus];
}
- (void)changeTextFieldStatus {
    //邮箱40位 手机号11位
    self.accountTextField.lengthLimit = 40;
    self.accountTextField.text =@"";
    if ([self.accountTextField canBecomeFirstResponder]) {
        [self.accountTextField becomeFirstResponder];
    }
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
#pragma mark - 下一步
- (IBAction)registClick:(UIButton *)sender {
    NSString * account = self.accountTextField.text.trimString;
    NSString * imageCode = self.imageTextField.text.trimString;
    NSString * code = self.codeTextField.text.trimString;
    
    if (!(account.isValidateMobile || account.isValidateEmail)){
        [AEBase alertMessage:@"请输入正确的手机号/邮箱!" cb:nil];
        return;
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
    [pramsDict setObject:account forKey:@"account"];
    [pramsDict setObject:code forKey:@"verify"];
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kRegisterAccount query:nil path:nil body:pramsDict success:^(id object) {
        [weakSelf hudclose];
        //下一步 设置昵称和密码
        AESetNickNamePwVC * vc = [AESetNickNamePwVC new];
        vc.account = account;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
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
    if (!(account.isValidateMobile || account.isValidateEmail)){
        [AEBase alertMessage:@"请输入正确的手机号/邮箱!" cb:nil];
        return;
    }
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kIsexists query:nil path:nil body:@{@"account":account} success:^(id object) {
        BOOL valid = object[@"valid"];
        if (valid) {
            [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kRegisterVerifyCode query:nil path:nil body:@{@"captcha":imageCode,@"account":account} success:^(id object) {
                [weakSelf hudclose];
                [AEBase alertMessage:@"验证码已发送..." cb:nil];
                [weakSelf circleProgressStart];
            } faile:^(NSInteger code, NSString *error) {
                [weakSelf hudclose];
                [AEBase alertMessage:error cb:nil];
                [weakSelf reSendImageCodeClick:nil];
                weakSelf.imageTextField.text = @"";
            }];
        }else {
            [weakSelf hudclose];
            [AEBase alertMessage:@"账户已注册" cb:nil];
        }
        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
        weakSelf.imageTextField.text = @"";
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
//返回
- (void)backAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
