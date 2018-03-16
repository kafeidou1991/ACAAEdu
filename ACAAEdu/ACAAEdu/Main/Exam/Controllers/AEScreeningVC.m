//
//  AEScreeningVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/14.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEScreeningVC.h"
#import "AEScreeningCell.h"
#import "AEScreenHeaderView.h"

static NSString * kAEScreeningCell = @"AEScreeningCell";
static NSString * kAEScreeningHeaderView = @"AEScreenHeaderView";

@interface AEScreeningVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UICollectionView * collectionView;

//已经选择的行列
@property (nonatomic, strong) NSMutableArray * selectIndexPaths;

@end

@implementation AEScreeningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = @[@[],
                        @[],
                        @[]].mutableCopy;
    self.selectIndexPaths = @[@"",@"",@""].mutableCopy;
    
    [self.view addSubview:self.collectionView];
}
- (void)afterProFun {
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kCategoryList query:nil path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        NSArray * array = [NSArray yy_modelArrayWithClass:[AEScreeningItem class] json:object];
        weakSelf.dataSource[0] = array;
        [weakSelf.collectionView reloadData];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
//    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kVersionList query:nil path:nil body:nil success:^(id object) {
//        [weakSelf hudclose];
//        NSArray * array = [NSArray yy_modelArrayWithClass:[AEScreeningItem class] json:object];
//        weakSelf.dataSource[1] = array;
//        [weakSelf.collectionView reloadData];
//    } faile:^(NSInteger code, NSString *error) {
//        [weakSelf hudclose];
//        [AEBase alertMessage:error cb:nil];
//    }];
//    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kCategoryList query:nil path:nil body:nil success:^(id object) {
//        [weakSelf hudclose];
//        NSArray * array = [NSArray yy_modelArrayWithClass:[AEScreeningItem class] json:object];
//        weakSelf.dataSource[0] = array;
//        [weakSelf.collectionView reloadData];
//    } faile:^(NSInteger code, NSString *error) {
//        [weakSelf hudclose];
//        [AEBase alertMessage:error cb:nil];
//    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource[section]count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AEScreeningCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAEScreeningCell forIndexPath:indexPath];
    AEScreeningItem * item = self.dataSource[indexPath.section][indexPath.row];
    
    [cell updateSubjectCell:item];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self resetSelectItem:indexPath.section];
    
    AEScreeningItem * item = self.dataSource[indexPath.section][indexPath.row];
    item.isSelect = !item.isSelect;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    });
    self.selectIndexPaths[indexPath.section] = indexPath;
//    //说明已选择过 应该恢复上个选择的内容
//    if ([self.selectIndexPaths[indexPath.section] isKindOfClass:[NSIndexPath class]]) {
//        NSIndexPath *  lastIndexPath = self.selectIndexPaths[indexPath.section];
//        AEScreeningCell * lastCell = (AEScreeningCell *)[collectionView cellForItemAtIndexPath:lastIndexPath];
//        AEScreeningItem * selectItem = self.dataSource[lastIndexPath.section][lastIndexPath.row];
//        selectItem.isSelect = !selectItem.isSelect;
//        [lastCell selectLabel:selectItem.isSelect];
//    }
//
//    AEScreeningItem * item = self.dataSource[indexPath.section][indexPath.row];
//    item.isSelect = !item.isSelect;
//    AEScreeningCell * selectCell = (AEScreeningCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [selectCell selectLabel:item.isSelect];
//
//
//    self.selectIndexPaths[indexPath.section] = indexPath;
    
    
//    //找到上次选择的 设置成未选择cell
//    NSIndexPath *  lastIndexPath = [self lastScreeningItem:indexPath];
//    if (lastIndexPath.row >= 0 && ![lastIndexPath isEqual:indexPath]) {
//      AEScreeningCell * lastCell = (AEScreeningCell *)[collectionView cellForItemAtIndexPath:lastIndexPath];
//        [lastCell selectLabel:NO];
//    }
//    //刷新当前选择cell
//    AEScreeningItem * item = self.dataSource[indexPath.section][indexPath.row];
//    item.isSelect = !item.isSelect;
//    AEScreeningCell * selectCell = (AEScreeningCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [selectCell selectLabel:item.isSelect];
}

- (void)resetSelectItem:(NSInteger)section {
    for (AEScreeningItem * item in self.dataSource[section]) {
        item.isSelect = NO;
    }
}

/**
 寻找出上次选择的cell

 @param indexPath 分区
 @return -1 是第一次选择
 */
- (NSIndexPath *)lastScreeningItem:(NSIndexPath *)indexPath {
//    NSIndexPath * tempIndex = [NSIndexPath indexPathForRow:-1 inSection:indexPath.section];
    NSInteger index = -1;
    for (NSInteger i = 0; i < [self.dataSource[indexPath.section]count]; i++) {
        AEScreeningItem * item = self.dataSource[indexPath.section][i];
        if (item.isSelect) {
            item.isSelect = NO;
            index = i;
            break;
        }
    }
    return [NSIndexPath indexPathForRow:index inSection:indexPath.section];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH,40);
}
//  返回头尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        AEScreenHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kAEScreeningHeaderView forIndexPath:indexPath];
        NSArray * array = self.dataSource[indexPath.section];
        header.hidden = !array.count;
        header.titleLabel.text = indexPath.section == 0 ? @"科目" : (indexPath.section == 1 ? @"类别" : @"版本");
        return header;
    }
    
    return nil;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40);
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 3, 50 );
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
        [_collectionView registerNib:[UINib nibWithNibName:@"AEScreeningCell" bundle:nil] forCellWithReuseIdentifier:kAEScreeningCell];
        // 注册header
        [_collectionView registerNib:[UINib nibWithNibName:@"AEScreenHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAEScreeningHeaderView];
        
    }
    return _collectionView;
}










@end
