//
//  NSString+category.m
//  iLearning
//
//  Created by Sidney on 13-8-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "NSString+category.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (category)

- (NSString *)appNextLineKeyword:(NSString *)word
{
    NSMutableString *temp = [[NSMutableString alloc] init];
    for (int i=0; i<[word length]; i++) {
        [temp appendFormat:@"%@", [word substringWithRange:NSMakeRange(i, 1)]];
        [temp appendFormat:@"\n"];
    }
    return temp;
}

#pragma mark Encryption
- (NSString *)stringFromMD5
{
    if(self == nil || [self length] == 0)
        return nil;
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02X",outputBuffer[count]];
    }
    return outputString;
}

#pragma mark Encryption
- (NSString*)sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:[self length]];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

- (CGSize)getSizeOfString:(UIFont *)font constroSize:(CGSize)size
{
    CGSize s = [self sizeWithFont:font constrainedToSize:size];
    return s;
}

- (CGSize)getSizeOfStringFontSize:(int)fontSize constroSize:(CGSize)size
{
    CGSize s = [self sizeWithFont:[UIFont systemFontOfSize:fontSize]
               constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return s;
}

- (BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidateMobile
{
    //手机号以13，14, 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    //    BOOL b = [phoneTest evaluateWithObject:mobile];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)validateCarNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:self];
}
- (BOOL)validateIdentityCard{
    if (self.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    //  NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:self]) return NO;
    //** 开始进行校验 *//
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]|| ![idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}



+ (NSString *)getCurrentDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [dateFormatter setDateFormat:WLBDateTimeFormat];
    //    [dateFormatter setDateFormat:@"HH(24制):hh(12制):mm 'on' EEEE MMMM d"];
    NSString * date = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"date%@",date);
    return date;
}

+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
//    [dateFormatter setDateFormat:WLBDateFormat];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
+ (NSString *)dateToStringFormatter:(NSString *)formatter date:(NSDate *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}


- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}

+ (NSString *)addComm:(NSString *)string
{
    NSString * str = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSInteger numl = [str length];
    
    if (numl > 3 && numl < 7) {
        str = [NSString stringWithFormat:@"%@,%@",
               [str substringWithRange:NSMakeRange(0,numl-3)],
               [str substringWithRange:NSMakeRange(numl-3,3)]];
        return str;
    }else if (numl>6 && numl < 10){
        str =  [NSString stringWithFormat:@"%@,%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-6)],
                [str substringWithRange:NSMakeRange(numl-6,3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
        return str;
    }else if (numl>9 && numl < 13){
        str =  [NSString stringWithFormat:@"%@,%@,%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-9)],
                [str substringWithRange:NSMakeRange(numl-9,3)],
                [str substringWithRange:NSMakeRange(numl-6,3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
        return str;
    }else {
        return str;
    }
}

+ (NSString *)removeComm:(NSString *)string{
    return [string stringByReplacingOccurrencesOfString:@"," withString:@""];
}

- (BOOL)wl_containsString:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    return range.length > 0;
}

#pragma mark - 加**处理
/// 对字符处做**替代处理 
///
/// @return 15811311063 => 1581****1063
- (NSString *)secretString {
    if (self.length < 8) return self;
    NSString *firstStr = [self substringWithRange:NSMakeRange(0, 4)];
    NSString *lastStr = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
    
    return [NSString stringWithFormat:@"%@****%@", firstStr, lastStr];
}

/// eg: 15811311063 => 158＊＊＊＊1063
- (NSString *)securityPhoneStr {
    if (self.length < 8) return self;
    NSString *firstStr = [self substringWithRange:NSMakeRange(0, 3)];
    NSString *lastStr = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
    
    return [NSString stringWithFormat:@"%@＊＊＊＊%@", firstStr, lastStr];
}

- (NSString *)secretIDString {
    if (self.length < 10) return self;
    NSString *firstStr = [self substringWithRange:NSMakeRange(0, 6)];
    NSString *lastStr = [self substringWithRange:NSMakeRange(self.length - 4, 4)];

    return [NSString stringWithFormat:@"%@*********%@", firstStr, lastStr];
}

#pragma mark - 去空格处理
/// 去掉字符串中的空格
- (NSString *)trimString {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/// 给字符串添加空格 例: 12345678 => 1234 5678
- (NSString *)addTrimString {
    if (self.length == 0) return self;
    
    NSString *trimStr = [self trimString];
    NSMutableString *strM = [NSMutableString stringWithString:self];
    if (trimStr.length > 2 && trimStr.length % 4 == 1) {
        [strM insertString:@" " atIndex:self.length - 1];
        return strM.copy;
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//每隔4位加空格 对于整体的字符
+ (NSString *)changStringWith:(NSString *)number {
    
    number = [number trimString];
    if (number.length <= 4) {
        return number;
    }
    NSString *mutStr = [NSString stringWithFormat:@""];
    for (NSInteger index = 0; index < number.length / 4; index ++) {
        NSRange range = NSMakeRange(index * 4, 4);
        NSString *str = [number substringWithRange:range];
        if (index == 0) {
            mutStr = [NSString stringWithFormat:@"%@", str];
        }
        else {
            mutStr = [NSString stringWithFormat:@"%@ %@", mutStr, str];
        }
    }
    if (number.length % 4) {
        NSString *str = [number substringFromIndex:number.length - number.length % 4];
        mutStr = [NSString stringWithFormat:@"%@ %@", mutStr, str];
    }
    return mutStr;
}

/// 电话号码添加空格 例: 15811311063 => 158 1131 1063
- (NSString *)addPhoneSpace {
    if (self.length < 4) return self;
    
    NSString *trimStr = [self trimString];
    NSMutableString *strM = [NSMutableString stringWithString:self];
    NSInteger length = trimStr.length;
    
    if (length == 4 || length == 8) { // 添加空格
        [strM insertString:@" " atIndex:self.length - 1];
        return strM.copy;
    }
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
/// 身份证号添加空格 130529199903335333 -> 130529 1999 0333 5333
- (NSString *)addIdCardSpace {
    if (self.length < 6) return self;

    NSString *trimStr = [self trimString];
    NSMutableString *strM = [NSMutableString stringWithString:self];
    NSInteger length = trimStr.length;
    
    if (length == 7 || length == 11 || length == 15) { // 添加空格
        [strM insertString:@" " atIndex:self.length - 1];
        return strM.copy;
    }
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSString*)addIdCardSpaceAtOCR{
    NSString *numberStr = [self trimString];
    if (numberStr.length <= 6) return numberStr;
    
    NSString *str1 = [numberStr substringToIndex:6];
    NSString *str2 = [numberStr substringWithRange:NSMakeRange(6, numberStr.length - 6)];
    if (str2.length <= 4) {
        return [NSString stringWithFormat:@"%@ %@", str1, str2];
    }
    NSString *mutStr = [NSString stringWithFormat:@""];
    for (NSInteger index = 0; index < str2.length / 4; index ++) {
        NSRange range = NSMakeRange(index * 4, 4);
        NSString *str = [str2 substringWithRange:range];
        if (index == 0) {
            mutStr = [NSString stringWithFormat:@"%@", str];
        }
        else {
            mutStr = [NSString stringWithFormat:@"%@ %@", mutStr, str];
        }
    }
    if (str2.length % 4) {
        NSString *str = [str2 substringFromIndex:str2.length - str2.length % 4];
        mutStr = [NSString stringWithFormat:@"%@ %@ %@", str1,mutStr, str];
    } else {
        mutStr = [NSString stringWithFormat:@"%@ %@", str1,mutStr];
    }

    return mutStr;
}
/// 电话号码添加空格 非实时 例: 15811311063 => 158 1131 1063
- (NSString*)addPhoneSpaceNoreal{
    NSString *numberStr = [self trimString];
    if (numberStr.length <= 3) return numberStr;
    
    NSString *str1 = [numberStr substringToIndex:3];
    NSString *str2 = [numberStr substringWithRange:NSMakeRange(3, numberStr.length - 3)];
    if (str2.length <= 4) {
        return [NSString stringWithFormat:@"%@ %@", str1, str2];
    }
    NSString *mutStr = [NSString stringWithFormat:@""];
    for (NSInteger index = 0; index < str2.length / 4; index ++) {
        NSRange range = NSMakeRange(index * 4, 4);
        NSString *str = [str2 substringWithRange:range];
        if (index == 0) {
            mutStr = [NSString stringWithFormat:@"%@", str];
        }
        else {
            mutStr = [NSString stringWithFormat:@"%@ %@", mutStr, str];
        }
    }
    if (str2.length % 4) {
        NSString *str = [str2 substringFromIndex:str2.length - str2.length % 4];
        mutStr = [NSString stringWithFormat:@"%@ %@ %@", str1,mutStr, str];
    } else {
        mutStr = [NSString stringWithFormat:@"%@ %@", str1,mutStr];
    }
    
    return mutStr;
}
- (NSString *)addEncryptPhoneSpaceNoreal {
    NSString *numberStr = [self trimString];
    if (numberStr.length <= 3) return numberStr;
    
    NSString *str1 = [numberStr substringToIndex:3];
    NSString *str2 = [numberStr substringWithRange:NSMakeRange(3, numberStr.length - 3)];
    if (str2.length <= 4) {
        return [NSString stringWithFormat:@"%@ %@", str1, str2];
    }
    NSString *mutStr = [NSString stringWithFormat:@""];
    for (NSInteger index = 0; index < str2.length / 4; index ++) {
        NSRange range = NSMakeRange(index * 4, 4);
        NSString *str = [str2 substringWithRange:range];
        if (index == 0) {
            mutStr = [NSString stringWithFormat:@"%@", str];
        }
        else {
            mutStr = [NSString stringWithFormat:@"%@ %@", mutStr, str];
        }
    }
    if (str2.length % 4) {
        NSString *str = [str2 substringFromIndex:str2.length - str2.length % 4];
        mutStr = [NSString stringWithFormat:@"%@ **** %@", str1, str];
    } else {
        mutStr = [NSString stringWithFormat:@"%@ %@", str1,mutStr];
    }
    
    return mutStr;
}
//计算字符串的字节数(汉字占两个)
+ (NSUInteger)calculateChineseCount:(NSString*)string{
    NSUInteger character =0;
    for(int i = 0; i< [string length];i++){
        int a = [string characterAtIndex:i];
        if( a >=0x4e00 && a <=0x9fa5){//判断是否为中文
            character +=2;
        }else{
            character +=1;
        }
    }
    return character;
}
//从字符串中截取指定字节数(汉字占两个)
- (NSString *)subStringByByteWithIndex:(NSInteger)index{
    NSInteger sum = 0;
    NSString *subStr = [[NSString alloc] init];
    for(int i = 0; i<[self length]; i++){
        
        unichar strChar = [self characterAtIndex:i];
        
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 2;
        }
        if (sum >= index) {
            subStr = [self substringToIndex:i+1];
            return subStr;
        }
    }
    return subStr;
}
@end
