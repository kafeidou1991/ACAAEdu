//
//  AEMyTestExamVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/26.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseTableController.h"

typedef NS_ENUM(NSInteger, TestExamType) {
    NoneTestExamType = 0,         //未考试
    HasTestExamType,  //已考试
};

@interface AEMyTestExamVC : AEBaseTableController

@property (nonatomic, assign) TestExamType examType;  //消息模式

@end
