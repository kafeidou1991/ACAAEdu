//
//  AESpaceItem.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/7.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEHomeModuleItem : NSObject
/**
 展示数据
 */
@property (nonatomic, strong) NSArray * data;

/**
 分区显示数据
 */
@property (nonatomic, strong) NSDictionary *sectionDict;


@end
