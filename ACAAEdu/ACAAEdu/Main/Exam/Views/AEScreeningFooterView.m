//
//  AEScreeningFooterVIew.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/16.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEScreeningFooterView.h"


@interface AEScreeningFooterView ()


@end

@implementation AEScreeningFooterView

- (IBAction)resetAction:(UIButton *)sender {
    if (_block) {
        _block(NO);
    }
}

- (IBAction)doneAction:(UIButton *)sender {
    if (_block) {
        _block(YES);
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.height = footViewHeight;
}


@end
