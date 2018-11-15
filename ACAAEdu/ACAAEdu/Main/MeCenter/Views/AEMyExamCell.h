//
//  AEMyExamCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/11/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateCenter.h"
@class AEMyExamItem;

static const CGFloat cellHeight = 60.f;

@interface AEMyExamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel; //考试结果
@property (weak, nonatomic) IBOutlet UILabel *examStatusLabel; //考试状态结果
@property (weak, nonatomic) IBOutlet UIImageView *examRightView; //右箭头
@property (weak, nonatomic) IBOutlet UIView *statusView;//左部状态条

/**
 我的模考列表
 
 @param item 数据
 @param done 标识是未考还是已考
 */
- (void)updateMyTestExamCell:(AEMyExamItem *)item done:(BOOL)done;

@end
