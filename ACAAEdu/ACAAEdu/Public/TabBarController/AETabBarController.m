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
#import "AEExamVC.h"

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
//    tabBarItemAppearance.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [tabBarAppearance setShadowImage:[UIImage new]];
    
    //去掉tabBar顶部线条
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [tabBarAppearance setBackgroundImage:img];
    [tabBarAppearance setShadowImage:img];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setupChildViewControllers];
}
#pragma mark - Private

- (void)setupChildViewControllers {
    [self addChildControllerName:@"AEHomePageVC" normalImage:[self layoutImageName:@"tabBar_home_h"] selectedImage:[self layoutImageName:@"tabBar_home_l"] title:@""];
    [self addChildControllerName:@"AEExamVC1" normalImage:[self layoutImageName:@"tabBar_acaa_h"] selectedImage:[self layoutImageName:@"tabBar_acaa_l"] title:@""];
    [self addChildControllerName:@"AEExamVC2" normalImage:[self layoutImageName:@"tabBar_autodesk_h"] selectedImage:[self layoutImageName:@"tabBar_autodesk_l"] title:@""];
    [self addChildControllerName:@"AEMeCenterVC" normalImage:[self layoutImageName:@"tabBar_me_h"] selectedImage:[self layoutImageName:@"tabBar_me_l"] title:@""];
}
- (NSString *)layoutImageName:(NSString *)imgName {
    //320 375 414  各个机型宽度
    if (SCREEN_WIDTH == 320.f) {
        return [imgName stringByAppendingString:@"_small"];
    }else if (SCREEN_WIDTH == 414) {
        return [imgName stringByAppendingString:@"_plus"];
    }
    return imgName;
}

- (void)addChildControllerName:(NSString *)controllerName
                   normalImage:(NSString *)normalImage
                 selectedImage:(NSString *)selectedImage
                         title:(NSString *)title {
    Class class;
    AEBaseController *controller;
    if ([controllerName isEqualToString:@"AEExamVC1"]) {
        controller = [[AEExamVC alloc]initWithType:AEExamACAAType];
    }else if ([controllerName isEqualToString:@"AEExamVC2"]) {
        controller = [[AEExamVC alloc]initWithType:AEExamAUTODESKType];
    }else {
        class = NSClassFromString(controllerName);
        controller = [class new];
    }
    
    UIImage *normalImg = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selectedImg = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    controller.title = title;
    
    UITabBarItem *item = controller.tabBarItem;
    //去除偏移
    item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
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
