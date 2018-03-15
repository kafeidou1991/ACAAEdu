//
//  AEOrderDetailCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/13.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AEExamItem;
@interface AEOrderDetailCell : UITableViewCell

/**
 单选模式
 
 @param item 数据
 */
- (void)updateCell:(AEExamItem *)item;

@end
