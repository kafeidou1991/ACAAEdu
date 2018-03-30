//
//  AEExamContentView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEExamContentView : UICollectionView


/**
 刷新数据源  同步会刷新视图

 @param data 数据
 */
- (void)refreshData:(AEExamQuestionItem *)data;

@end
