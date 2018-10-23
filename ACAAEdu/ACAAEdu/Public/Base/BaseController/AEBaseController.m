//
//  AEBaseController.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"

@interface AEBaseController ()<UIGestureRecognizerDelegate>{
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
    [self addSubViews];
    [self performSelector:@selector(afterProFun) withObject:nil afterDelay:0.15];
    self.view.backgroundColor = AEColorBgVC;
}
- (void)addSubViews {
    //添加views
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) { // 导航控制器的根控制器不做处理
        _interactivePopGestureRecognizerDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relogin) name:kreLogin object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_interactivePopGestureRecognizerDelegate) {
        self.navigationController.interactivePopGestureRecognizer.delegate = _interactivePopGestureRecognizerDelegate;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kreLogin object:nil];
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

- (AEBaseTopView *)baseTopView {
    if (!_baseTopView) {
        ySpace = IS_IPHONEX ? 88 : 64;
        _baseTopView = [[AEBaseTopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ySpace)];
    }
    return _baseTopView;
}



//x进行一些网络请求
- (void)afterProFun{
}
- (void)relogin {
    [AELoginVC OpenLogin:self callback:^(BOOL compliont) {
//        [self afterProFun];
    }];
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

-(void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
