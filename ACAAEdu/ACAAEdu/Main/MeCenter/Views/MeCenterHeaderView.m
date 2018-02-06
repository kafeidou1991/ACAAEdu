//
//  MeCenterHeaderView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "MeCenterHeaderView.h"

@implementation MeCenterHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60.f);
    }
    return self;
}

- (IBAction)loginClick:(UIButton *)sender {
    if (_loginBlock) {
        _loginBlock();
    }
}


@end
