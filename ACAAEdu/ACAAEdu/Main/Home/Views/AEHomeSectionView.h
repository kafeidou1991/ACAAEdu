//
//  AEHomeSectionView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2019/1/17.
//  Copyright © 2019 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AEHomeSectionView : UIView
/**
 更新banner数据
 
 @param dict dict数组
 */
- (void)updateSectionView:(NSDictionary *)dict;

@property (nonatomic, copy) dispatch_block_t expandBlock;

@end

NS_ASSUME_NONNULL_END
