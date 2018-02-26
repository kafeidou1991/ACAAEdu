//
//  ExameCollectionView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/8.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "ExameCollectionView.h"
#import "ExamCollectionLayout.h"
#import "AEHomeCollectionCell.h"

@interface ExameCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ExameCollectionView

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"AEHomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AEHomeCollectionCell class])];
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
    AEHomeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AEHomeCollectionCell class]) forIndexPath:indexPath];
    return cell;
}
@end
