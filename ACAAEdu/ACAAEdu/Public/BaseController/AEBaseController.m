//
//  AEBaseController.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"

@interface AEBaseController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation AEBaseController{
    id<UIGestureRecognizerDelegate> _interactivePopGestureRecognizerDelegate; ///< 系统滑动返回代理
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //兼容第三方键盘
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 0;
    [self performSelector:@selector(afterProFun) withObject:nil afterDelay:0.3];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) { // 导航控制器的根控制器不做处理
        _interactivePopGestureRecognizerDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
    self.navigationController.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_interactivePopGestureRecognizerDelegate) {
        self.navigationController.interactivePopGestureRecognizer.delegate = _interactivePopGestureRecognizerDelegate;
    }
}

- (void)afterProFun{
}



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//    [self.navigationController setNavigationBarHidden:isShowHomePage animated:animated];
}



@end
