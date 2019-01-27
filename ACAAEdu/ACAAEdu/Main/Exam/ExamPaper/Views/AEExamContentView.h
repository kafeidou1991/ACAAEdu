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
//记录已经滚动到第几页
typedef void(^DidScrollePage)(int page);
//判断是否是最后一页m，改变按钮文案
typedef void (^IsLastPageBlock)(BOOL last,int index);

@interface AEExamContentView : UICollectionView

@property (nonatomic, assign) QuestionType questionType;

/**
 提交回调
 */
@property (nonatomic, copy) dispatch_block_t submitExamBlock;

/**
 已经滚动到第几页，发生滚动之后才会调用 第一页的时候不会调用
 */
@property (nonatomic, copy)  DidScrollePage  didScrollePage;

/**
 刷新数据源  同步会刷新视图

 @param data 数据
 */
- (void)refreshData:(AEExamQuestionItem *)data;

/**
 滚动下一题

 @param isNext 是否是下一题 上一题
 */
- (void)scrollQuestion:(BOOL)isNext;

/**
 是否是最后一题
 */
@property (nonatomic, copy) IsLastPageBlock lastBlock;


@end
