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
#import "UIDevice+FCUUID.h"

@interface MeCenterHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation MeCenterHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200.f);
        
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200.f);
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
        self.nameLabel.text = STRISEMPTY(User.user_profile.user_name) ? [NSString stringWithFormat:@"%@", User.username] : [NSString stringWithFormat:@"%@", User.user_profile.user_name];
    }else {
        self.nameLabel.text = @"点击头像登录";
    }
    self.iconImageView.image = [UIImage imageNamed:@"mecenter_headnomal"];
}

- (void)updateVisitorHeaderInfo {
    if (Visotor.isShow) {
        if (Visotor.isLogin) {
            //设备唯一标识符
            NSString * uuid = [UIDevice currentDevice].uuid;
            self.nameLabel.text = [NSString stringWithFormat:@"iOS游客-%@", uuid.length > 4 ? [uuid substringWithRange:NSMakeRange(0, 4)] : uuid];
            self.iconImageView.image = [UIImage imageNamed:@"mecenter_head_visitor"];
        }
    }
}


@end
