//
//  CollectionViewCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AEMyExamItem,AEExamItem;
typedef void(^BuyMoreBlock)(UIButton *);
static const CGFloat cellHeight = 80.f;

@interface AEHomePageCell : UITableViewCell
/**
 考试列表单选模式

 @param item 数据
 */
- (void)updateCell:(AEExamItem *)item;
/**
 考试列表多选模式
 
 @param item 数据
 */
- (void)updateMoreCell:(AEExamItem *)item;
/**
 我的模考列表
 
 @param item 数据
 @param done 标识是未考还是已考
 */
- (void)updateMyTestExamCell:(AEMyExamItem *)item done:(BOOL)done;
/**
 购买回调
 */
@property (nonatomic, copy) dispatch_block_t buyBlock;
/**
 多选时回调
 */
@property (nonatomic, copy) BuyMoreBlock moreBlock;

@end
