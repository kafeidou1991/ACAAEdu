//
//  CollectionViewCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AEMyExamItem,AEExamItem;
static const CGFloat cellHeight = 50.f;

@interface AEHomePageCell : UITableViewCell
/**
 考试列表单选模式

 @param item 数据
 */
- (void)updateCell:(AEExamItem *)item;

/**
 购买回调
 */
@property (nonatomic, copy) dispatch_block_t buyBlock;


@end
