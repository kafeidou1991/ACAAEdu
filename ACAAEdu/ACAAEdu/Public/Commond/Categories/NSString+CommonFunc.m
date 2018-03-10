//
//  NSString+CommonFunc.m
//  WangliBank
//
//  Created by xiafan on 9/25/14.
//  Copyright (c) 2014 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "NSString+CommonFunc.h"

@implementation NSString (CommonFunc)

- (NSString *)addColons
{
    NSString *numberString = self;
    
    BOOL hasDot;
    
    hasDot = [numberString rangeOfString:@"."].location != NSNotFound;
    
    if (hasDot) { // 0000.00
        NSArray *parts = [numberString componentsSeparatedByString:@"."];
        NSMutableString *part1 = [NSMutableString stringWithString:[parts firstObject]];
        NSString *part2 = [parts lastObject];
        
        if (part1.length > 3) {
            
            part1 = [part1 addColon4String];
            part1 = (NSMutableString *)[part1 stringByAppendingFormat:@".%@", part2];
            
            return part1;
        }
    } else { // 0000
        return [numberString addColon4String];
    }
    
    return numberString;
}

- (NSMutableString *)addColon4String
{
    NSMutableString *colonString = [NSMutableString stringWithString:self];
    
    int step = 3;
    int len = (int)colonString.length;
    while (len - step > 0) {
        [colonString insertString:@"," atIndex:(len - step)];
        step += 3;
    }
    return colonString;
}

// 155******89
- (NSString *)encryptString
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    NSUInteger length = mutableString.length;
    NSRange range = NSMakeRange(0, 0);
    NSString *replaceString = @"";
    
    if (length > 1 && length < 5) {// Name
        range = NSMakeRange(0, 1);
        replaceString = @"*";
    }
    if (length == 11) {// PhoneNo
        range = NSMakeRange(3, 6);
        replaceString = @"******";
    }
    if (length > 15) {// IdentityCardNo
        range = NSMakeRange(length-4, 4);
        replaceString = @"****";
    }
    return [mutableString stringByReplacingCharactersInRange:range withString:replaceString];
}
- (NSString *)encryptString2
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    NSUInteger length = mutableString.length;
    
    if (length<15) {
        return [self encryptString];
    }
    
    NSString *string_top = [mutableString substringWithRange:NSMakeRange(0, 4)];
    NSString *string_end = [mutableString substringWithRange:NSMakeRange(length-4, 4)];

    NSMutableString * xingStr= [[NSMutableString alloc]init];
    for (int k=0; k<length-8; k++) {
        [xingStr appendString:@"*"];
    }
    mutableString = [NSMutableString stringWithFormat:@"%@%@%@",string_top,xingStr,string_end];
    
    return mutableString;
}

/// eg. 张恒力 -> ××力
- (NSString *)encryptName {
    NSInteger length = self.length;
    
    if (length < 2) return self;
    
    NSMutableString *strM = [NSMutableString stringWithString:self];
    NSRange range = NSMakeRange(0, strM.length - 1);
    
    NSMutableString *xingStr= [[NSMutableString alloc]init];
    for (int k=0; k<range.length; k++) {
        [xingStr appendString:@"*"];
    }
    
    return [strM stringByReplacingCharactersInRange:range withString:xingStr];
}

/// 去掉字符串中的空格
- (instancetype)trimString {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/// 给字符串添加空格 例: 12345678 => 1234 5678
- (instancetype)addTrimString {
    if (self.length == 0) return self;
    
    NSString *trimStr = [self trimString];
    NSMutableString *strM = [NSMutableString stringWithString:self];
    if (trimStr.length > 2 && trimStr.length % 4 == 1) {
        [strM insertString:@" " atIndex:self.length - 1];
        return strM;
    }
    return self;
}
- (instancetype)riceWithSpaceString {
    
    if (self.length == 0) return self;
    NSString *firstString;
    NSString *lastString;
    if (self.length == 16) {
        firstString = [self substringWithRange:NSMakeRange(0, 4)];
        lastString = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
        return [NSString stringWithFormat:@"%@ **** **** %@", firstString, lastString];
    } else {// 19位
        firstString = [self substringWithRange:NSMakeRange(0, 4)];
        lastString = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
        return [NSString stringWithFormat:@"%@ **** **** *** %@", firstString, lastString];
    }
}

#pragma mark - 加**处理
/// 对字符处做**替代处理
///
/// @return 15811311063 => 1581****1063
- (instancetype)secretString {
    if (self.length < 8) return self;
    NSString *firstStr = [self substringWithRange:NSMakeRange(0, 3)];
    NSString *lastStr = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
    
    return [NSString stringWithFormat:@"%@****%@", firstStr, lastStr];
}

- (instancetype)secretIDString {
    if (self.length < 10) return self;
    NSString *firstStr = [self substringWithRange:NSMakeRange(0, 6)];
    NSString *lastStr = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
    
    return [NSString stringWithFormat:@"%@******%@", firstStr, lastStr];
}

#pragma mark - 时间处理
/// 去掉秒 eg: 2016-09-19 11:50:24 -> 2016-09-19 11:50
- (instancetype)trimSeconds {
    if (self.length != 19) return self;
    
    return [self substringToIndex:16];
}

- (NSString *)timeDifference {
    // 1.创建一个时间格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 2.格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // 3.字符串转换成时间/自动转换0时区/东加西减
    NSDate *date = [formatter dateFromString:self];
    NSDate *now = [NSDate date];
    
    //
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit type = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    
    // 4.获取了时间元素
    NSDateComponents *cmps = [calendar components:type fromDate:now toDate:date options:0];
    
    if (cmps.day < 1) {
        return [NSString stringWithFormat:@"%ld小时即可后生效",(long)cmps.hour];
    }
    return [NSString stringWithFormat:@"%ld天后即可生效",(long)cmps.day];
}

- (NSString *)convertWithFormat:(NSString *)formatString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:self];
    formatter.dateFormat = formatString;
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

- (NSString *)keepTwoDecimalPlaces {
    CGFloat floatValue = [self floatValue];
    CGFloat result = floor(floatValue / 100) * 100;
    return [NSString stringWithFormat:@"%.2f",result];
}

#pragma mark - urlstr
- (BOOL)isUrl
{
    if(self == nil)
        return NO;
    NSString *url;
    if (self.length>4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",self];
    }else{
        url = self;
    }
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}

@end






