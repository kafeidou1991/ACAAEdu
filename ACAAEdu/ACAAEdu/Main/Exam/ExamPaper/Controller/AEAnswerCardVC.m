//
//  AEAnswerCardVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/31.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEAnswerCardVC.h"
#import "AEAnswerCardCell.h"
#import "AnswerCardReusableView.h"
#import "AEExamResultVC.h"

@interface AEAnswerCardVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    UICollectionView *_contentCollectionView;
    UIButton *_finishButton;
    TestPaperTagView *_statusTagView;
    CGFloat buttonHeight;
    CGFloat testPaperStatusHeight;
    NSString *_submitStr;
}

@end
@implementation AEAnswerCardVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    buttonHeight = 49.0;
    testPaperStatusHeight = 40.0f;
    self.title = @"答题卡";
    self.view.backgroundColor = UIColorFromRGB(0xF0F2F6);
    _submitStr = @"提交";
    [self createCollectionView];
    [self createFinishTest];
    [self createTestPaperStatusTag];
    if (self.isTimeOut) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)createFinishTest
{
    if (_finishButton == nil) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishButton.frame = CGRectMake(100, self.view.frame.size.height- NAVIGATION_HEIGHT - buttonHeight + 10, self.view.frame.size.width - 100*2, buttonHeight - 10*2);
        _finishButton.layer.cornerRadius = 5.0f;
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _finishButton.backgroundColor = AEThemeColor;
        NSString *str = @"提交试卷";
        [_finishButton setTitle:str forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishButton.alpha = 0.9;
        [_finishButton addTarget:self action:@selector(submitTest:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_finishButton];
}

- (void)createTestPaperStatusTag
{
    CGFloat spaceWidth = 12.0f;
    TestPaperTagView * view = [[TestPaperTagView alloc] initWithFrame:CGRectMake(spaceWidth, self.view.frame.size.height- NAVIGATION_HEIGHT - buttonHeight - testPaperStatusHeight, SCREEN_WIDTH - spaceWidth*2, testPaperStatusHeight)];
    _statusTagView = view;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_statusTagView];
}

- (void)submitTest:(UIButton *)sender{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"确认交卷?" message:@"请确认提交本次考试" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"交卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WS(weakSelf);
        [self hudShow:self.view msg:@"正在提交答案..."];
        //每个部分的考试id的一致的，所以取出来一个就可以
        AEExamQuestionItem * item = self.paperData[0];
        [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kSubmitExam query:nil path:nil body:@{@"exam_id":item.id} success:^(id object) {
            [weakSelf hudclose];
            AEExamResultVC * VC = [AEExamResultVC new];
            VC.examId = item.id;
            [weakSelf.navigationController pushViewController:VC animated:YES];
            
        } faile:^(NSInteger code, NSString *error) {
            [weakSelf hudclose];
            [AEBase alertMessage:error cb:nil];
        }];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)createCollectionView
{
    if (_contentCollectionView == nil) {
        CGFloat itemLineNum = 5,spaceWidth = 12;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
//        26
        flowLayout.itemSize = CGSizeMake(26, 26);
        flowLayout.minimumLineSpacing = 19.0f;
        flowLayout.minimumInteritemSpacing = (SCREEN_WIDTH - 25*itemLineNum)/(itemLineNum+1);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, (SCREEN_WIDTH - 25*itemLineNum)/(itemLineNum+1), 19/2, 10);
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40);
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(spaceWidth, spaceWidth, SCREEN_WIDTH - spaceWidth*2, self.view.height - NAVIGATION_HEIGHT- buttonHeight - spaceWidth - testPaperStatusHeight) collectionViewLayout:flowLayout];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        [_contentCollectionView registerClass:[AEAnswerCardCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
        [_contentCollectionView registerClass:[AnswerCardReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderIdentifier"];
    }
    [self.view addSubview:_contentCollectionView];
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
        [reusableHeaderView setLabelText:item.part_name];
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedBlock && !self.isTimeOut) {
        self.selectedBlock(indexPath);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
