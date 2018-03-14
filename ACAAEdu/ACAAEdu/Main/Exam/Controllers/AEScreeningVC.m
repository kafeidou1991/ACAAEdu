//
//  AEScreeningVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/14.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEScreeningVC.h"
#import "AEScreeningCell.h"

static NSString * kAEScreeningCell = @"AEScreeningCell";

@interface AEScreeningVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation AEScreeningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AEScreeningCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAEScreeningCell forIndexPath:indexPath];
    
    return cell;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        //    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, accountHeaderHeight);
            flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2,60);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        //暂时隐藏
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT) collectionViewLayout:flowLayout];
        
        // 设置UICollectionView的其他相关属性
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.collectionView];
        
        // 注册cell
        [self.collectionView registerNib:[UINib nibWithNibName:@"AEScreeningCell" bundle:nil] forCellWithReuseIdentifier:kAEScreeningCell];
        // 注册header
//        [_collectionView registerNib:[UINib nibWithNibName:@"WLHHHCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
//        [_collectionView registerNib:[UINib nibWithNibName:@"WLAccountSpaceReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerSpaceViewIdentifier];
        
    }
    return _collectionView;
}










@end
