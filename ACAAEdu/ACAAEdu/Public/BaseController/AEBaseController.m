//
//  AEBaseController.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"

@interface AEBaseController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>{
    MBProgressHUD   *_mbProgressHud;
}

@end

@implementation AEBaseController{
    id<UIGestureRecognizerDelegate> _interactivePopGestureRecognizerDelegate; ///< 系统滑动返回代理
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //兼容第三方键盘
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 0;
    //统一左部返回键
    self.navigationItem.leftBarButtonItem = [self createLeftBarBackItemHandle];
    [self performSelector:@selector(afterProFun) withObject:nil afterDelay:0.3];
    self.view.backgroundColor = AEColorBgVC;
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
- (UIBarButtonItem *)createLeftBarBackItemHandle{
    UIImage * image = [UIImage imageNamed:@"ic_global_return"];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    btn.bounds = CGRectMake(0, 0, 60, 40);
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, - btn.width + MIN(image.size.width, 14), 0, 0);
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//x进行一些网络请求
- (void)afterProFun{
}

- (void)hudShow:(UIView *)inView msg:(NSString *)msgText{
    if (_mbProgressHud == nil) {
        _mbProgressHud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    }
    _mbProgressHud.contentColor = [UIColor whiteColor];
    _mbProgressHud.bezelView.color = [UIColor blackColor];
    _mbProgressHud.label.text = msgText;
    _mbProgressHud.animationType = MBProgressHUDAnimationZoom;
    [_mbProgressHud showAnimated:YES];
}
- (void)hudclose{
    if (_mbProgressHud) {
        [_mbProgressHud removeFromSuperview];
        [_mbProgressHud hideAnimated:NO];
        _mbProgressHud = nil;
    }
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
