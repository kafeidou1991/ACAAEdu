//
//  AEScreeningCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/14.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEScreeningCell : UICollectionViewCell
/**
 更新类别cell

 @param item model
 */
- (void)updateSubjectCell:(AEScreeningItem *)item;

/**
 是否选中

 @param isSelect 是否选中
 */
- (void)selectLabel:(BOOL)isSelect;

@end
