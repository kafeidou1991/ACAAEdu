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
@property (nonatomic, strong) AEExamQuestionItem * data;


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
        self.scrollEnabled = NO;
    }
    return self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.question.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AEExamContentCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AEExamContentCell class]) forIndexPath:indexPath];
    
    [cell updateCell:self.data.question[indexPath.item]];
    
    return cell;
}
-(void)scrollQuestion:(BOOL)isNext {
    int page = self.contentOffset.x / self.width;
    if (isNext) {
        [self updateAnswer:page];
        if (page != self.data.question.count - 1) {
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        }else {
            if (_submitExamBlock) {
                _submitExamBlock();
            }
        }
    }else {
        if (page != 0) {
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        }else {
            [AEBase alertMessage:@"没有上一题了" cb:nil];
        }
    }
    
}
//上传答案
- (void)updateAnswer:(int)page {
    AEQuestionRresult * result = self.data.question[page];
    //上报答案
    if (STRISEMPTY(result.answer)) {
        return;
    }
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kSubmitQuestion query:nil path:nil body:@{@"part_id":result.part_id,@"sheet_id":result.sheet_id,@"answer":result.answer} success:^(id object) {
        NSLog(@"提交答案成功");
    } faile:^(NSInteger code, NSString *error) {
        [AEBase alertMessage:error cb:nil];
    }];
}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
//    AEQuestionRresult * result = self.data.question[page];
//    //上报答案
//    if (STRISEMPTY(result.answer)) {
//        return;
//    }
//    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kSubmitQuestion query:nil path:nil body:@{@"part_id":result.part_id,@"sheet_id":result.sheet_id,@"answer":result.answer} success:^(id object) {
//        NSLog(@"提交答案成功");
//    } faile:^(NSInteger code, NSString *error) {
//        [AEBase alertMessage:error cb:nil];
//    }];
//}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size;
}

@end
