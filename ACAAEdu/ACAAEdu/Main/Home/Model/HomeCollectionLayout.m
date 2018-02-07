//
//  HomeCollectionLayout.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "HomeCollectionLayout.h"

static const CGFloat space = 10.f;
static const CGFloat cellHeight = 80.f;


@implementation HomeCollectionLayout

-(instancetype)init {
    if (self = [super init]) {
        self.itemSize = CGSizeMake(SCREEN_WIDTH - 2 * space, cellHeight);
        self.minimumLineSpacing = space;
        self.minimumInteritemSpacing = space;
        self.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
    }
    return self;
}

@end
