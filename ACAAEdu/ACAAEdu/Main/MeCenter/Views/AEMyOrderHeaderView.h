//
//  AEMyOrderHeaderView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEMyOrderHeaderView : UIView

- (void)updateContent:(AEMyOrderList *)item;

@property (nonatomic, copy) dispatch_block_t clickBlock;

@end
