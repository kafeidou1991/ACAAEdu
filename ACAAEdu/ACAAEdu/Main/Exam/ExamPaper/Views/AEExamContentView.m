//
//  AEExamContentView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamContentView.h"
#import "AEExamContentCell.h"

@interface AEExamContentView ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    int questionCount;
    int lastPage; //上报答案时用
}
/**
 试题数据源
 */
@property (nonatomic, strong) AEExamQuestionItem * data;

@end


@implementation AEExamContentView

//刷新数据源
-(void)refreshData:(AEExamQuestionItem *)data {
    self.data = data;
    questionCount = (int)self.data.question.count;
    lastPage = 0;
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
        lastPage = 0;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.question.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AEExamContentCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AEExamContentCell class]) forIndexPath:indexPath];
    
    [cell updateCell:self.data.question[indexPath.item]];
    
    //选择答案，上传答案
    WS(weakSelf)
    cell.selectAnswerBlock = ^{
        [weakSelf updateAnswer];
    };
    
    return cell;
}
- (void)scrollQuestion:(BOOL)isNext{
    int page = self.contentOffset.x / self.width;
    //即将显示最后一页   //试卷就一道题
    if (isNext && (questionCount == 1 || page == questionCount - 2 || page == questionCount - 1)) {
        if (_lastBlock) {
            _lastBlock(YES,page);
        }
    }else {
        if (_lastBlock) {
            _lastBlock(NO,page);
        }
    }
    //上一题 下一题
    if (isNext) {
        if (page != questionCount - 1) {
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
//MARK: 点击下一题结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    int page = self.contentOffset.x / self.width;
    if (_didScrollePage) {
        _didScrollePage(page + 1);
    }
}
//MARK: 滑动下一题结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = self.contentOffset.x / self.width;
    //滚动到了jj第几题
    if (_didScrollePage) {
        _didScrollePage(page + 1);
    }
    //滑动显示 是否交卷
    if (_lastBlock) {
        _lastBlock((questionCount == 1 || page == questionCount - 1),page);
    }
}
//上传答案
- (void)updateAnswer{
    int page = self.contentOffset.x / self.width;
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
