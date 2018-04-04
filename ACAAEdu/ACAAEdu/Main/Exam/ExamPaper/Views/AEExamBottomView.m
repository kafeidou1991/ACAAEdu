//
//  AEExamBottomView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/4.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamBottomView.h"

@implementation AEExamBottomView



- (IBAction)doAction:(UIButton *)sender {
    if (_block) {
        _block((int)sender.tag);
    }
}


@end
