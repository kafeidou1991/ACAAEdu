//
//  AEExamContentView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QuestionType) {
    SignleQuestionType = 0, //单选题
    DoubleQuestionType,   //多选题
    JudgeQuestionType,    //判断题
};

@interface AEExamContentView : UICollectionView

@property (nonatomic, assign) QuestionType questionType;

/**
 刷新数据源  同步会刷新视图

 @param data 数据
 */
- (void)refreshData:(AEExamQuestionItem *)data;

@end
