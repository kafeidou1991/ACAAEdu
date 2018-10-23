//
//  AETabBarController.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AETabBarController.h"
#import "AENavigationController.h"
#import "AEBaseController.h"

@interface AETabBarController ()<UITabBarControllerDelegate>

@end

@implementation AETabBarController

+ (void)load {
    UITabBarItem *tabBarItemAppearance = [UITabBarItem appearance];
    NSDictionary *normalAttr = @{NSFontAttributeName: [UIFont wlfontWithName:AECustomFont size:9], NSForegroundColorAttributeName: AEHexColor(@"#777777")};
    NSDictionary *selectedAttr = @{NSFontAttributeName: [UIFont wlfontWithName:AECustomFont size:9], NSForegroundColorAttributeName: AEThemeColor};
    [tabBarItemAppearance setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [tabBarItemAppearance setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    
    // 字体和图片的偏移
    tabBarItemAppearance.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setupChildViewControllers];
}

#pragma mark - Private

- (void)setupChildViewControllers {
    [self addChildControllerName:@"AEHomePageVC" normalImage:@"tabBar_home_l" selectedImage:@"tabBar_home_h" title:@""];
    [self addChildControllerName:@"AEExamVC" normalImage:@"tabBar_exam_l" selectedImage:@"tabBar_exam_h" title:@"考试"];
    [self addChildControllerName:@"AEMeCenterVC" normalImage:@"tabBar_me_l" selectedImage:@"tabBar_me_h" title:@"我的"];
}

- (void)addChildControllerName:(NSString *)controllerName
                   normalImage:(NSString *)normalImage
                 selectedImage:(NSString *)selectedImage
                         title:(NSString *)title {
    Class class = NSClassFromString(controllerName);
    AEBaseController *controller = [class new];
    
    UIImage *normalImg = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selectedImg = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.title = title;
    
    UITabBarItem *item = controller.tabBarItem;
    item.image = normalImg;
    item.selectedImage = selectedImg;
    
    
    UINavigationController *navi = [[AENavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:navi];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
//    if (![WLUserInfo shareInstance].isLogin) {
//        WLNavigationController *nav = (WLNavigationController *)viewController;
//        UIViewController *rootVC = nav.viewControllers[0];
//        if ([rootVC isKindOfClass:[WLMeVC class]]) {
//            [self presentViewController:[WLLoginVC loginVCWithNavigation] animated:YES completion:nil];
//            return NO;
//        }
//    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    AENavigationController *nav = (AENavigationController *)viewController;
    UIViewController *rootVC = nav.viewControllers[0];
//    if ([rootVC isKindOfClass:NSClassFromString(@"WLHomePageVC")]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationTabBarSelectHomeVC object:nil];
//    }
}



@end
