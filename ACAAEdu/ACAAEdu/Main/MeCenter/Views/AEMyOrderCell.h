//
//  AEMyOrderCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEMyOrderCell : UITableViewCell

/**
 充填数据

 @param item 数据
 */
- (void)updateCell:(AEGoodItem *)item;

@end
