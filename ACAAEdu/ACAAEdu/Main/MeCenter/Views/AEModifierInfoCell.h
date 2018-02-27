//
//  AEUserInfoCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/19.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEModifierInfoCell : UITableViewCell

- (void)updateCell:(NSDictionary * )dict;
//点击接棒或者帮顶
@property (nonatomic, copy) dispatch_block_t actionBlock;
@end
