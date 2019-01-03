//
//  AEAnswerCardView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/1.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEAnswerCardView.h"
#import "AEAnswerCardCell.h"
#import "AnswerCardReusableView.h"

@interface AEAnswerCardView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation AEAnswerCardView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    CGFloat itemLineNum = 5;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(26, 26);
    flowLayout.minimumLineSpacing = 19.0f;
    flowLayout.minimumInteritemSpacing = (SCREEN_WIDTH - 25*itemLineNum)/(itemLineNum+1);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, (SCREEN_WIDTH - 25*itemLineNum)/(itemLineNum+1), 19/2, 10);
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40);
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[AEAnswerCardCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
        [self registerClass:[AnswerCardReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderIdentifier"];
    }
    return self;
}
-(void)setPaperData:(NSMutableArray *)paperData {
    _paperData = paperData;
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.paperData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    AEExamQuestionItem * item = self.paperData[section];
    return item.question.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CollectionCellIdentifier";
    AEAnswerCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //序号显示
    cell.numLabel.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
    AEExamQuestionItem * item = self.paperData[indexPath.section];
    AEQuestionRresult * result = item.question[indexPath.row];
    //只有两个状态 一个未答 一个已答 //空值是未答
    if (STRISEMPTY(result.answer)) {
        [cell setBackgroundColorWithStatus:TestResultStatusUnfinished];
    }else {
        [cell setBackgroundColorWithStatus:TestResultStatusFinished];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
        AnswerCardReusableView *reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderIdentifier" forIndexPath:indexPath];
        AEExamQuestionItem * item = self.paperData[indexPath.section];
        [reusableHeaderView setLabelText:item.questionName];
        reusableView = reusableHeaderView;
    }
    return reusableView;
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 40);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 19/2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 19;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectblock) {
        self.selectblock(indexPath);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}





@end
