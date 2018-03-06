//
//  AEHomeCollectionView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "HomeCollectionView.h"
#import "AEHomeCollectionCell.h"
#import "HomeCollectionLayout.h"
#import "AEOrderDetailVC.h"

@interface HomeCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)HomeHeaderReusableView * headerView;

//数据源
@property (nonatomic, strong) NSArray * dataSources;

@end

@implementation HomeCollectionView

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame dataSources:(NSArray *)data {
    self.dataSources = data;
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"AEHomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AEHomeCollectionCell class])];
        [self registerNib:[UINib nibWithNibName:@"HomeHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HomeHeaderReusableView class])];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    layout = [HomeCollectionLayout new];
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
    }
    return self;
}
//更新banner
-(void)updateBanner:(NSArray *)array {
    if (self.headerView) {
        [self.headerView updateBanner:array];
    }
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
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        HomeHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HomeHeaderReusableView class]) forIndexPath:indexPath];
        if (view == nil) {
            view = [[HomeHeaderReusableView alloc] init];
        }
        self.headerView = view;
        
        return view;
    }else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 200);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewController.navigationController pushViewController:[AEOrderDetailVC new] animated:YES];
}




@end
