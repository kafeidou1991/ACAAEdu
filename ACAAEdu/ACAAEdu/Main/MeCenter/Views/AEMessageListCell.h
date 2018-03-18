//
//  AEMessageListCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/16.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat cellHeight = 60.f;

@interface AEMessageListCell : UITableViewCell

- (void)updateCell:(AEMessageList *)item;

@end
