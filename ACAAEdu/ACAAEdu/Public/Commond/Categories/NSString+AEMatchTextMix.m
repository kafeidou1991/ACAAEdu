//
//  NSString+AEMatchTextMix.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/2.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "NSString+AEMatchTextMix.h"

@implementation NSString (AEMatchTextMix)

- (NSArray *)matchTextImageMix {
    if (STRISEMPTY(self)) {
        return @[];
    }
    NSMutableArray * tempArray = @[].mutableCopy;
//    NSString * content = @"<img border='0' src='http://acaa.adsk-certification.cn/examData/acaa/FS/2017/201705/FS_2017_106.png' />呵呵呵";
    NSString *pattern =@"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>";  //正则过滤
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSUInteger start = 0;
    for (NSTextCheckingResult *match in matches)
    {
        NSString *str = [self substringWithRange:NSMakeRange(start, match.range.location-start)];
        if (!STRISEMPTY(str)) {
            [tempArray addObject:str];
        }
        NSString *imgSrc = [self substringWithRange:match.range];
        if (!STRISEMPTY(imgSrc)) {
            [tempArray addObject:imgSrc];
        }
        start = match.range.location+match.range.length;
    }
    NSString *lastStr = [self substringFromIndex:start];
    if (!STRISEMPTY(lastStr)) {
        [tempArray addObject:lastStr];
    }
    return tempArray.copy;
}


@end
