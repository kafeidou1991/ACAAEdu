//
//  AEOrderDetailFooterView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/13.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEOrderDetailFooterView.h"

@implementation AEOrderDetailFooterView


- (IBAction)buyNowAction:(UIButton *)sender {
    if (_buyNowBlock) {
        _buyNowBlock();
    }
}



@end
