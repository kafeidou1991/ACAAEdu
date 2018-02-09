//
//  ExameCollectionView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/8.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "ExameCollectionView.h"
#import "ExamCollectionLayout.h"
#import "HomeCollectionCell.h"

@interface ExameCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ExameCollectionView

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HomeCollectionCell class])];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    layout = [ExamCollectionLayout new];
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
    }
    return self;
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10.f;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectionCell class]) forIndexPath:indexPath];
    return cell;
}
@end
