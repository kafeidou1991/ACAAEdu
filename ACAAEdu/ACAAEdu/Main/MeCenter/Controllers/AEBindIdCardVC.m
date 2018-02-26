//
//  AECheckIdCardVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/26.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBindIdCardVC.h"

@interface AEBindIdCardVC ()
@property (weak, nonatomic) IBOutlet AETextField *idCardTextField;
@property (weak, nonatomic) IBOutlet AETextField *nameTextField;

@end

@implementation AEBindIdCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"绑定身份证";
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (IBAction)bindClick:(UIButton *)sender {
    NSString * idCard = self.idCardTextField.text.trimString;
    NSString * name =self.nameTextField.text.trimString;
    if (![idCard validateIdentityCard]) {
        [AEBase alertMessage:@"身份证格式错误" cb:nil];
        return;
    }
    if (STRISEMPTY(name)) {
        [AEBase alertMessage:@"请输入真实姓名" cb:nil];
        return;
    }
    
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kBindIdCard query:nil path:nil body:@{@"id_card":idCard,@"user_name":name,@"card_type":@"0"} success:^(id object) {
        [weakSelf hudclose];
        [AEBase alertMessage:@"绑定成功" cb:nil];
        User.id_card = idCard;
        [User save];
        [[NSNotificationCenter defaultCenter]postNotificationName:kBindAccountSuccess object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
    
}


@end
