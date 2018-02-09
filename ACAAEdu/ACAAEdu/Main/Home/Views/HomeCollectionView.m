//
//  AEHomeCollectionView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "HomeCollectionView.h"
#import "HomeCollectionCell.h"
#import "HomeCollectionLayout.h"

@interface HomeCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)HomeHeaderReusableView * headerView;

@end

@implementation HomeCollectionView

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HomeCollectionCell class])];
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
    return 10.f;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectionCell class]) forIndexPath:indexPath];
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





@end
