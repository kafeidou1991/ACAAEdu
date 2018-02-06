//
//  HomeCollectionLayout.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "HomeCollectionLayout.h"

@implementation HomeCollectionLayout

-(instancetype)init {
    if (self = [super init]) {
        self.itemSize = CGSizeMake((SCREEN_WIDTH - 30)/2, 120);
        self.minimumLineSpacing = 10.f;
        self.minimumInteritemSpacing = 10.f;
        self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return self;
}

@end
