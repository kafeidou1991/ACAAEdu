//
//  NSString+EncodeXMLCharacters.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2019/1/28.
//  Copyright © 2019 ACAA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (EncodeXMLCharacters)
//替换XML中的特殊字符
- (NSString *)encodeXMLCharacters;

- (NSString *)decodeXMLCharacters;
@end

NS_ASSUME_NONNULL_END
