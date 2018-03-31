//
//  AEAnswerCardVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/31.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"
//答题卡

typedef void(^SelectedItemBlock)(NSIndexPath *indexPath);

@interface AEAnswerCardVC : AEBaseController

@property (nonatomic, assign) BOOL isTimeOut;
@property (nonatomic, copy) SelectedItemBlock selectedBlock;
//@property (nonatomic, copy) NSArray *paperData; // 试卷数据

@property (nonatomic, copy) NSMutableArray * paperData;

@end
