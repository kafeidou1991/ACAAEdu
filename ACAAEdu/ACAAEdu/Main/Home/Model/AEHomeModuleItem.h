//
//  AESpaceItem.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/7.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AEHomeSectionItem;
@interface AEHomeModuleItem : NSObject
/**
 展示数据
 */
@property (nonatomic, strong) NSArray * data;

/**
 分区显示数据
 */
@property (nonatomic, strong) AEHomeSectionItem * sectionItem;


@end


@interface AEHomeSectionItem : NSObject

/**
 显示的图片
 */
@property (nonatomic, copy) NSString *image;

/**
 显示的内容
 */
@property (nonatomic, copy) NSString *title;

/**
 分区背景颜色
 */
@property (nonatomic, copy) NSString *backgroundColor;

/**
 是否关闭展开
 */
@property (nonatomic, assign) BOOL isExpand;

@end
