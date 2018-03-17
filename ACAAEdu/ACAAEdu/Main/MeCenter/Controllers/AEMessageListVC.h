//
//  AEMessageListVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/16.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseTableController.h"

typedef NS_ENUM(NSInteger, MessageListType) {
    UnReadMessageListType = 0,  //未读
    ReadMessageListType         //已读
};

@interface AEMessageListVC : AEBaseTableController

@property (nonatomic, assign) MessageListType messageType;  //消息模式

@end
