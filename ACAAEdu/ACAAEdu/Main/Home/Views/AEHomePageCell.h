//
//  CollectionViewCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AEExamItem;

static const CGFloat cellHeight = 80.f;

@interface AEHomePageCell : UITableViewCell

- (void)updateCell:(AEExamItem *)item;
/**
 购买回调
 */
@property (nonatomic, copy) dispatch_block_t buyBlock;

@end
