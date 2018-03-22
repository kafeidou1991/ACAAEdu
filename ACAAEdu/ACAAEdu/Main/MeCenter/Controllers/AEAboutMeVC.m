//
//  AEAboutMeVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/8.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEAboutMeVC.h"

@interface AEAboutMeVC ()
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;

@end

@implementation AEAboutMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.appNameLabel.text = AEAppName;
    self.appVersionLabel.text = [NSString stringWithFormat:@"iPhone V%@",AEVersion];
    
    
    //配置环境
#ifdef DEBUG
    self.navigationItem.rightBarButtonItem = [AEBase createCustomBarButtonItem:self action:@selector(changeServer) title:@"    "];
#endif
}
// 内部测试功能
- (void)changeServer {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络环境切换仅供开发、测试人员使用" message:[self getNetworkDomain] preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *officialEnv = [UIAlertAction actionWithTitle:@"正式环境：id.acaa.cn" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ChangeServerEnv];
    }];
    
    UIAlertAction *localTestTan = [UIAlertAction actionWithTitle:@"测试环境：www.iww123.com" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:ChangeServerEnv];
    }];
    
    UIAlertAction *localTestCong = [UIAlertAction actionWithTitle:@"测试环境：www.bagua9.com" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:ChangeServerEnv];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:officialEnv];
    [alert addAction:localTestTan];
    [alert addAction:localTestCong];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)getNetworkDomain {
    NSString * domain = @"http://id.acaa.cn/";
    NSString * temp = [AEUserDefaults objectForKey:ChangeServerEnv];
    if (STRISEMPTY(temp)) {
        return domain;
    }
    if (temp.integerValue == 1) {
        return domain;
    }else if (temp.integerValue == 2) {
        domain = @"http://www.iww123.com/";
    }else {
        domain = @"http://www.bagua9.com/";
    }
    return domain;
}


@end
