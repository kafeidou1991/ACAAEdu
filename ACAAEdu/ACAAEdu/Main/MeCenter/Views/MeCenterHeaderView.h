//
//  MeCenterHeaderView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCenterHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, copy) dispatch_block_t loginBlock;
@end
