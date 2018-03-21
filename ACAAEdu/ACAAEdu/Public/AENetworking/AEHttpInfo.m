//
//  AEHttpInfo.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEHttpInfo.h"

@implementation AEHttpInfo


- (id)init{
    if (self = [super init]) {
        self.platform = @"ios";
        self.timestamp = [NSString stringWithFormat:@"%lu",(unsigned long)[NSDate date].timeIntervalSince1970];
#ifdef DEBUG
        self.networkDomain = [self getNetworkDomain];
#else
        self.networkDomain = @"http://id.acaa.cn/";
#endif
        
        self.apiToken = @"";
    }
    return self;
}

- (NSString *)getNetworkDomain {
    NSString * domain = @"http://id.acaa.cn/";
    NSString * temp = [AEUserDefaults objectForKey:ChangeServerEnv];
    if (STRISEMPTY(temp)) {
        return domain;
    }
    if (temp.integerValue == 1) {
        return domain;
    }else if (temp.integerValue == 2) {
        domain = @"http://www.iww123.com/";
    }else {
        domain = @"http://www.bagua9.com/";
    }
    return domain;
}

@end
