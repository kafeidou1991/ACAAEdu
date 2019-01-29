//
//  AEVistiorInfo.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2019/1/29.
//  Copyright © 2019 ACAA. All rights reserved.
//

#import "AEVistiorInfo.h"
#import "AEBaseController.h"

static AEVistiorInfo * info = nil;

@implementation AEVistiorInfo {
    AEBaseController * currViewController;
    LoginCompliont compliontBlock;
}
//MARK: 判断是否显示游客模式下
//判断当前版本是否跟系统版本一直，一致的话使用接口返回，其他为no，这样做是为了受到防止升级时候影响
- (BOOL)isShow {
    if ([_version isEqualToString:AEVersion]) {
        return _isShow;
    }else {
        return NO;
    }
}
//MARK: 选择登录方式
- (void)alertLoginType:(AEBaseController *)viewController Compliont:(LoginCompliont)compliont {
    currViewController = viewController;
    compliontBlock = compliont;
    //未登录 提供游客模式下登录，其他情况应因为push前外部进行了登录判断，所以不会出现未登录在此页面的情况。
    if (Visotor.isShow) {
        if (!User.isLogin) {
            //已经游客登录 无需重新登录
            if (_isLogin) {
                if (compliontBlock) {
                    compliontBlock();
                }
            }else {
                [self selectLoginType];
            }
        }else {
            if (compliontBlock) {
                compliontBlock();
            }
        }
    } else {
        if (User.isLogin) {
            if (compliontBlock) {
                compliontBlock();
            }
        }else {
            [AELoginVC OpenLogin:currViewController callback:^(BOOL compliont) {
                if (compliont) {
                    if (compliontBlock) {
                        compliontBlock();
                    }
                }
            }];
        }
    }
}
- (void)selectLoginType {
    WS(weakSelf)
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"登录提示" message:@"请选择注册登录，在其他iOS设备上也可以参加考试，游客登录只能在本台iOS设备参加考试。" preferredStyle:UIAlertControllerStyleAlert];
    //本地登录
    UIAlertAction * loginAction = [UIAlertAction actionWithTitle:@"注册登录(推荐)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AELoginVC OpenLogin:currViewController callback:^(BOOL compliont) {
            if (compliont) {
                if (compliontBlock) {
                    compliontBlock();
                }
            }
        }];
    }];
    [loginAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    [alertVC addAction:loginAction];
    
    //游客登录 15837219106 123456  默认apple游客账户
    UIAlertAction * visitorAction = [UIAlertAction actionWithTitle:@"游客登录(仅限本设备)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf visitorLogin:YES];
    }];
    [visitorAction setValue:AEHexColor(@"999999") forKey:@"titleTextColor"];
    [alertVC addAction:visitorAction];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不登录" style:UIAlertActionStyleDefault handler:nil];
    [cancelAction setValue:AEHexColor(@"999999") forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    [currViewController presentViewController:alertVC animated:YES completion:nil];
}
//MARK: 游客购买登录
- (void)visitorLogin:(BOOL)isLoad {
    //登录成功
    WS(weakSelf)
    NSDictionary * paramsDic = @{ @"username":@"15837219106",
                                  @"password":@"123456",
                                  @"scene":@"acount"};
    if (isLoad) {
        [currViewController hudShow:currViewController.view msg:STTR_ater_on];
    }
    //接口有延迟，先显示出来 后台等待接口加载
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kLogin query:nil path:nil body:paramsDic.mutableCopy success:^(id object) {
        if (isLoad) {
            [currViewController hudclose];
        }
        weakSelf.isLogin = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:kVisitorLoginSuccess object:nil];
        if (compliontBlock) {
            compliontBlock();
        }
    } faile:^(NSInteger code, NSString *error) {
        if (isLoad) {
            [currViewController hudclose];
        }
    }];
}

//MARK: Single Instance
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!info) {
            info = [AEVistiorInfo new];
        }
    });
    return info;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [super allocWithZone:zone];
    });
    return info;
}
- (id)copyWithZone:(NSZone *)zone {
    return [AEUserInfo shareInstance];
}


@end
