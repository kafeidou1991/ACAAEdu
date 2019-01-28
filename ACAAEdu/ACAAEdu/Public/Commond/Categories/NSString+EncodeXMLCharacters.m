//
//  NSString+EncodeXMLCharacters.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2019/1/28.
//  Copyright © 2019 ACAA. All rights reserved.
//

#import "NSString+EncodeXMLCharacters.h"

@implementation NSString (EncodeXMLCharacters)

#pragma mark - 替换字符
- (NSString *)encodeXMLCharacters{
    if (!self) {
        return @"";
    }
    
    NSString *result = [NSString stringWithString:self];
    
    if ([result rangeOfString:@"&"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"&"] componentsJoinedByString:@"&amp;"];
    }
    
    if ([result rangeOfString:@"<"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"<"] componentsJoinedByString:@"&lt;"];
    }
    
    if ([result rangeOfString:@">"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@">"] componentsJoinedByString:@"&gt;"];
    }
    
    if ([result rangeOfString:@"\""].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"\""] componentsJoinedByString:@"&quot;"];
    }
    
    if ([result rangeOfString:@"'"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"'"] componentsJoinedByString:@"&apos;"];
    }
    
    return result;
}

- (NSString *)decodeXMLCharacters {
    if (!self) {
        return @"";
    }
    
    NSString *result = [NSString stringWithString:self];
    
    if ([result rangeOfString:@"&amp;"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"&amp;"] componentsJoinedByString:@"&"];
    }
    
    if ([result rangeOfString:@"&lt;"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"&lt;"] componentsJoinedByString:@"<"];
    }
    
    if ([result rangeOfString:@"&gt;"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"&gt;"] componentsJoinedByString:@">"];
    }
    
    if ([result rangeOfString:@"&quot;"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"&quot;"] componentsJoinedByString:@"\""];
    }
    
    if ([result rangeOfString:@"&apos;"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"&apos;"] componentsJoinedByString:@"'"];
    }
    
    if ([result rangeOfString:@"&nbsp;"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"&nbsp;"] componentsJoinedByString:@" "];
    }
    
    if ([result rangeOfString:@"&#8220;"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"&#8220;"] componentsJoinedByString:@"\""];
    }
    
    if ([result rangeOfString:@"&#8221;"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"&#8221;"] componentsJoinedByString:@"\""];
    }
    
    if ([result rangeOfString:@"&#039;"].location != NSNotFound)
    {
        result = [[result componentsSeparatedByString:@"&#039;"] componentsJoinedByString:@"'"];
    }
    return result;
}

@end
