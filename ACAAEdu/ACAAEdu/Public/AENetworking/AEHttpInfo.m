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
//        self.networkDomain = @"http://www.iww123.com/";
        self.networkDomain = @"http://id.acaa.cn/";
//        self.networkDomain = @"http://www.bagua9.com/";
        self.apiToken = @"";
    }
    return self;
}

@end
