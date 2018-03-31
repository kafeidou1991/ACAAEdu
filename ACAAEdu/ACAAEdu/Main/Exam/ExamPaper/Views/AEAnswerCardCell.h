//
//  AnswerCardCollectionCell.h
//  wyzc
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 北京我赢科技有限公司. All rights reserved.
//  答题卡cell

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TestResultStatus) {
    TestResultStatusUnfinished = 0,
    TestResultStatusFinished,
};

@interface AEAnswerCardCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *numLabel;

- (void)setBackgroundColorWithStatus:(TestResultStatus)status;

@end
