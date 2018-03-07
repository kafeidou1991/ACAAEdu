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
#import "AEOrderDetailVC.h"

@interface ExameCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

//数据源
@property (nonatomic, strong) NSArray * dataSources;

@end

@implementation ExameCollectionView

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame dataSources:(NSArray *)data {
    self.dataSources = data;
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
    return self.dataSources.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AEHomeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AEHomeCollectionCell class]) forIndexPath:indexPath];
    WS(weakSelf)
    cell.buyBlock = ^{
        [weakSelf.viewController.navigationController pushViewController:[AEOrderDetailVC new] animated:YES];
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewController.navigationController pushViewController:[AEOrderDetailVC new] animated:YES];
}


@end
