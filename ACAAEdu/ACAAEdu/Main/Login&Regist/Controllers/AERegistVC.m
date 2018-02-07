//
//  AERegistVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/7.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AERegistVC.h"

typedef NS_ENUM(NSInteger, RegistType) {
    MobileRegistType = 100,
    EmileRegistType,
};


@interface AERegistVC ()
/**
注册方式
 */
@property (nonatomic, assign) RegistType registType;
/**
 底部横线左约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstrain;

@end

@implementation AERegistVC

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    [self initComonpent];
    
}
- (void)initComonpent {
    self.registType = MobileRegistType;
//    [self changeTextFieldStatus];
}

#pragma mark - 切换注册方式
- (IBAction)changeRegistClick:(UIButton *)sender {
    //选择相同的item直接返回不做处理
    if (self.registType == sender.tag) {
        return;
    }
    self.registType = sender.tag;
    [self changeButtonStatus];
//    [self changeTextFieldStatus];
}
- (void)changeButtonStatus {
    UIButton * accountBtn = [self.view viewWithTag:100];
    UIButton * cardBtn = [self.view viewWithTag:101];
    accountBtn.selected = !accountBtn.selected;
    cardBtn.selected = !cardBtn.selected;
    self.bottomViewConstrain.constant = accountBtn.isSelected ? 0 : cardBtn.x;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}





@end
