//
//  AENavigationController.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AENavigationController.h"

@interface AENavigationController ()<UINavigationControllerDelegate>

@end

@implementation AENavigationController

+ (void)load {
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:AEThemeColor] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont wlfontWithName:AECustomFont size:18]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    //    self.delegate = self;
    self.navigationBar.shadowImage = [UIImage new];
//    self.navigationBar.tintColor   = AEFontColor;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
