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

typedef NS_ENUM(NSInteger, AESectionType) {
    AEHomeSectionType = 0,
    AEACAASectionType //ACAA分类页面
};
@interface AEHomeSectionView : UIView
/**
 分类样式 初始化一些背景颜色什么的
 */
@property (nonatomic, assign) AESectionType type;
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
