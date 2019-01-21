//
//  AEHomeSectionView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2019/1/17.
//  Copyright © 2019 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AEHomeSectionItem,AEAcaaCategoryItem;
@interface AEHomeSectionView : UIView
/**
 更新首页分区数据
 
 @param item 数据源
 */
- (void)updateSectionView:(AEHomeSectionItem *)item;

/**
 更新ACAA分类分区数据

 @param item 数据源
 */
- (void)updateACAACategaoryView:(AEAcaaCategoryItem *)item;


@property (nonatomic, copy) dispatch_block_t expandBlock;

@end

NS_ASSUME_NONNULL_END
