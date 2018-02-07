//
//  NSObject+entend.h
//  WangliBank
//
//  Created by xuehan on 16/1/8.
//  Copyright (c) 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//


@interface NSObject (entend)
/**
 *  返回格式化后的数字,目的是返回末尾没有0的小数值,最多保留两位小数
 *
 *  @param value 要格式化的float值
 *
 *  @return 返回格式化后的 数字 字符串
 */
- (NSString *)formatWithValue:(double)value;

/// 如果是0 最后样式为0.00
- (NSString *)formatWithValueZero:(double)value;
@end
