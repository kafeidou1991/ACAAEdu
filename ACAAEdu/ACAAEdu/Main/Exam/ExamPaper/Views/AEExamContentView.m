//
//  AEExamContentView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamContentView.h"
#import "AEExamContentCell.h"


@interface AEExamContentView ()<UICollectionViewDelegate, UICollectionViewDataSource>
/**
 试题数据源
 */
@property (nonatomic, strong)AEExamQuestionItem * data;


@end


@implementation AEExamContentView

//刷新数据源
-(void)refreshData:(AEExamQuestionItem *)data {
    self.data = data;
    
    [self reloadData];
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    UICollectionViewFlowLayout * vlf = [[UICollectionViewFlowLayout alloc]init];
    vlf.minimumLineSpacing = 0;
    vlf.minimumInteritemSpacing = 0;
    vlf.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    vlf.itemSize = CGSizeMake(self.width, self.height);
    vlf.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if (self = [super initWithFrame:frame collectionViewLayout:vlf]) {
        [self registerNib:[UINib nibWithNibName:@"AEExamContentCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AEExamContentCell class])];
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.question.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AEExamContentCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AEExamContentCell class]) forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    [cell updateCell:self.data.question[indexPath.item]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size;
}

@end
