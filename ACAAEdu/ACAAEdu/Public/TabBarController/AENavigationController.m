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

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:AEHexColor(@"333333"),NSFontAttributeName:[UIFont wlfontWithName:AECustomFont size:18]};
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:AEHexColor(@"FFFFFF"),NSFontAttributeName:[UIFont wlfontWithName:AECustomFont size:18]};
    //状态栏白色
    self.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:AEThemeColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShow =  [viewController isKindOfClass:NSClassFromString(@"AECustomSegmentVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEHomePageVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEExamVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEExamAnalyzeVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEExamInfoVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEMeCenterVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AESettingVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEAboutMeVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEAccountSetVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEModifierInfoVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEBindIdCardVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEMyTestExamVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEUserInfoVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEExamPaperVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AEExamAnalyzeVC")]
                 ||[viewController isKindOfClass:NSClassFromString(@"AELoginVC")]
    ;
    [navigationController setNavigationBarHidden:isShow animated:YES];
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
