//
//  NSObject+entend.m
//  WangliBank
//
//  Created by xuehan on 16/1/8.
//  Copyright (c) 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "NSObject+entend.h"

@implementation NSObject (entend)
- (NSString *)formatWithValue:(double)value{
    NSString * testNumber = [NSString stringWithFormat:@"%f",value];
    NSRange range = [testNumber rangeOfString:@"."];
    
    testNumber = [testNumber substringToIndex:range.location+3];
    
    NSString * s = nil;
    int offset = (int)(testNumber.length - 1);
    while (offset)
    {
        s = [testNumber substringWithRange:NSMakeRange(offset, 1)];
        if([s isEqualToString:@"."]){
            offset--;
            break;
        }else{
            if ([s isEqualToString:@"0"])
            {
                offset--;
            }
            else
            {
                break;
            }
        }
    }
    NSString *outNumber = [testNumber substringToIndex:offset+1];
    return outNumber;
}

- (NSString *)formatWithValueZero:(double)value {
    if (value == 0) {
        return @"0.00";
    }
    
    return [self formatWithValue:value];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (void)setNilValueForKey:(NSString *)key{};
@end
