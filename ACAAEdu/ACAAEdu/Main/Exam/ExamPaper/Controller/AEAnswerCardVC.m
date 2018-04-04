//
//  AEAnswerCardVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/31.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEAnswerCardVC.h"
#import "AnswerCardReusableView.h"
#import "AEExamResultVC.h"
#import "AEAnswerCardView.h"

@interface AEAnswerCardVC (){
    UIButton *_finishButton;
    TestPaperTagView *_statusTagView;
    CGFloat buttonHeight;
    CGFloat testPaperStatusHeight;
    NSString *_submitStr;
}
@property (nonatomic, strong) AEAnswerCardView * answerCardView;

@end
@implementation AEAnswerCardVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    buttonHeight = 49.0;
    testPaperStatusHeight = 40.0f;
    self.title = @"答题卡";
    self.view.backgroundColor = UIColorFromRGB(0xF0F2F6);
    _submitStr = @"提交";
    [self createFinishTest];
    [self createTestPaperStatusTag];
    WS(weakSelf)
    self.answerCardView.selectblock = ^(NSIndexPath *indexPath) {
        if (weakSelf.selectedBlock) {
            weakSelf.selectedBlock(indexPath);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
- (void)setPaperData:(NSMutableArray *)paperData {
    _paperData = paperData;
    self.answerCardView.paperData = _paperData;
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
        [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kSubmitExam query:nil path:nil body:@{@"exam_id":item.exam_id} success:^(id object) {
            [weakSelf hudclose];
            AEExamResultVC * VC = [AEExamResultVC new];
            VC.examId = item.exam_id;
            [weakSelf.navigationController pushViewController:VC animated:YES];
            
        } faile:^(NSInteger code, NSString *error) {
            [weakSelf hudclose];
            [AEBase alertMessage:error cb:nil];
        }];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (AEAnswerCardView *)answerCardView {
    if (!_answerCardView) {
        CGFloat spaceWidth = 12;
        _answerCardView = [[AEAnswerCardView alloc]initWithFrame:CGRectMake(spaceWidth, spaceWidth, SCREEN_WIDTH - spaceWidth*2, self.view.height - NAVIGATION_HEIGHT- buttonHeight - spaceWidth - testPaperStatusHeight)];
        [self.view addSubview:_answerCardView];
    }
    return _answerCardView;
}

@end
