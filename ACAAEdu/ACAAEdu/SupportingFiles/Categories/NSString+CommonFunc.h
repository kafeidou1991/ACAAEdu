//
//  NSString+CommonFunc.h
//  WangliBank
//
//  Created by xiafan on 9/25/14.
//  Copyright (c) 2014 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//


@interface NSString (CommonFunc)

/**
 *eg. 10,000,000.0
 */
- (NSString *)addColons;


/**
 *eg. 155*******89
 */
- (NSString *)encryptString;
/**
 *eg. 6225*******8888
 */
- (NSString *)encryptString2;

/// eg. 张恒力 -> ××力
- (NSString *)encryptName;

/// 去掉字符串中的空格
- (instancetype)trimString;

/// 给字符串添加空格 例: 12345678 => 1234 5678
- (instancetype)addTrimString;

#pragma mark - 加**处理
/// 对字符处做**替代处理 保留前3位和后4位,中间用*代替
///
/// @return 15811311063 => 1581****1063
- (instancetype)secretString;

/// 保留前六位和后四位,中间的用*代替
///
/// @return 500222199309296130 => 500222******6130
- (instancetype)secretIDString;

/// 保留前四位和后n位（n = 1，2，3）,中间的用*代替，并加空格
- (instancetype)riceWithSpaceString;

#pragma mark - 时间处理

/// 去掉秒 eg: 2016-09-19 11:50:24 -> 2016-09-19 11:50
- (instancetype)trimSeconds;
/// 计算时间差
- (NSString *)timeDifference;
// 日期字符串处理
// yyyy-MM-dd HH:mm:ss Z
// yyyy年MM月dd日 HH时mm分ss秒 Z
- (NSString *)convertWithFormat:(NSString *)formatString;
// 保留两位小数
- (NSString *)keepTwoDecimalPlaces;

#pragma mark - urlstr
- (BOOL)isUrl;

@end
