//
//  MeCenterHeaderView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "MeCenterHeaderView.h"
#import "AEAboutMeVC.h"
#import "AEUserInfoVC.h"

@interface MeCenterHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation MeCenterHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60.f);
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60.f);
    }
    return self;
}
//跳转个人中心
- (IBAction)loginClick:(UITapGestureRecognizer *)sender {
    if (!User.isLogin) {
        [AELoginVC OpenLogin:self.viewController callback:nil];
    }else {
        [self.viewController.navigationController pushViewController:[AEUserInfoVC new] animated:YES];
    }
}

-(void)updateheaderInfo {
    if (User.isLogin) {
        self.nameLabel.text =User.username;
    }else {
        self.nameLabel.text = @"登录";
    }
}


@end
