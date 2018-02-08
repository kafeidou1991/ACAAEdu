//
//  ExamCollectionLayout.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/8.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "ExamCollectionLayout.h"

static const CGFloat space = 10.f;
static const CGFloat cellHeight = 80.f;

@implementation ExamCollectionLayout

-(instancetype)init {
    if (self = [super init]) {
        self.itemSize = CGSizeMake(SCREEN_WIDTH, cellHeight);
        self.minimumLineSpacing = space;
        self.minimumInteritemSpacing = space;
        self.sectionInset = UIEdgeInsetsMake(space, 0, space, 0);
    }
    return self;
}

@end
