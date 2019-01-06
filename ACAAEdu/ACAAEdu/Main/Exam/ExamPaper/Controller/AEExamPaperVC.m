//
//  AETestPaperVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/4.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamPaperVC.h"
#import "AEExamItem.h"
#import "AEExamContentView.h"
#import "AEAnswerCardVC.h"
#import "AEExamBottomView.h"
#import "AEExamTimeView.h"
#import "AEExamAnalyzeVC.h"

static CGFloat const bottomViewHeight = 50.f;
static CGFloat const timeViewHeight = 50.f;

@interface AEExamPaperVC ()
/**
 题型数组 试题全部数据  因为获取试题接口返回 全部数据，可覆盖部分试题接口返回的数据
 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
/**
 定时器
 */
@property (nonatomic, strong) AETimerHelper * timer;
/**
 显示倒计时
 */
@property (nonatomic, strong) AEExamTimeView * timerView;
/**
 答题卡
 */
@property (nonatomic, strong) AEAnswerCardVC * answerCardVC;
/**
 显示考题View
 */
@property (nonatomic, strong) AEExamContentView * contentView;
/**
 底部view
 */
@property (nonatomic, strong) AEExamBottomView * bottomView;

@end

@implementation AEExamPaperVC
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_timer) {
        [_timer resumeTimer];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //暂停定时器
    if (_timer) {
        [_timer pauseTimer];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self topNavtiation];
    WS(weakSelf)
    self.answerCardVC.selectedBlock = ^(NSIndexPath *indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        });
    };
    
    
    
}
//MARK: 请求数据
/**
 考试的逻辑是 ：
 先进行开始考试接口，然后返回来 考试id --》 用考试id来请求对应的题型接口也就是部分考题接口 值选择part_type== 1的基础题  去请求对用的考题展示。。 时间到 进行交卷
 ***/
-(void)afterProFun {
    WS(weakSelf)
    [self startExamPaper:^(AEExamQuestionItem * item) {
        [weakSelf getPartExamPaper:item];
    }];
}
//开始考试
- (void)startExamPaper:(void(^)(AEExamQuestionItem *))success {
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kStartExamPaper query:nil path:nil body:@{@"exam_id":self.examItem.id} success:^(id object) {
        AEExamQuestionItem * item = [AEExamQuestionItem yy_modelWithJSON:object];
        if (success) {
            success(item);
        }
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
//获取基础题部分试卷
- (void)getPartExamPaper:(AEExamQuestionItem *)item{
    WS(weakSelf);
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kPartExamPaper query:@{@"user_exam_id":item.id}.mutableCopy path:nil body:nil success:^(id object) {
        NSMutableArray * tempArr = @[].mutableCopy;
        //剔除status == 2 已考完的考题  "part_type" : "1", 基础题类型的题目
        NSArray * dataArray = [NSArray yy_modelArrayWithClass:[AEExamQuestionItem class] json:object];
        for (AEExamQuestionItem * item in dataArray) {
            if ([item.status isEqualToString:@"1"] && [item.part_type isEqualToString:@"1"] && item) {
                [tempArr addObject:item];
            }
        }
        if (tempArr.count > 0) {
            //获取第一部分 基础题试题
            [weakSelf getPartExamQuestionIndex:tempArr[0]];
        }else {
            [weakSelf hudclose];
//            [AEBase alertMessage:@"该考卷已经考完，请选择其他考卷" cb:nil];
            if (dataArray.count > 0) {
                AEExamQuestionItem * timeoutItem = dataArray[0];
                [weakSelf timeOutAction:timeoutItem.exam_id];
                
            }
        }
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
//根据部分题型  type 1-判断题2-单选题3-复选题
- (void)getPartExamQuestionIndex:(AEExamQuestionItem *)item{
    WS(weakSelf);
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kPartExamQuestion query:@{@"exam_part_id":item.id}.mutableCopy path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        //已经获取到全部试题  替换数据源
        AEExamQuestionItem * item = [AEExamQuestionItem yy_modelWithJSON:object];
        weakSelf.dataSourceArr = [NSMutableArray arrayWithObject:item];
        //添加视图
        [weakSelf createMainContentView];
        
        //开启定时器
        [weakSelf openTimer:item.count_down_time.integerValue];
        //设置题目数
        weakSelf.timerView.examNumLabel.text = [NSString stringWithFormat:@"1 / %ld",item.question.count];
        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
//MARK: 定时器
- (void)openTimer:(NSTimeInterval)countdown {
    WS(weakSelf)
    [self.timer countDownTimeInterval:countdown completeBlock:^(NSString *timeString, BOOL finish) {
        if (!finish) {
            weakSelf.timerView.timeLabel.text = timeString;
        }else {
            //考试结束 应该交卷
            [weakSelf timeCountDownAction];
        }
    }];
}
//MARK: 主动提交
- (void)submitTest{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"确认交卷?" message:@"请确认提交本次考试" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"交卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [self submit:@""];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//MARK: 倒计时结束
- (void)timeCountDownAction {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"交卷" message:@"考试时间已到，请交卷" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"交卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submit:@""];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//MARK: 考卷超时
- (void)timeOutAction:(NSString *)exam_id {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"交卷" message:@"考试时间已经结束，请交卷" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"交卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submit:exam_id];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)submit:(NSString *)exam_id {
    WS(weakSelf);
    [self hudShow:self.view msg:@"正在提交答案..."];
    //每个部分的考试id的一致的，所以取出来一个就可以
    if (self.dataSourceArr.count > 0) {
       AEExamQuestionItem * item = self.dataSourceArr[0];
        exam_id = item.exam_id;
    }
    if (STRISEMPTY(exam_id)) {
        [AEBase alertMessage:@"暂无考试id，请返回重新刷新" cb:nil];
        return;
    }
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kSubmitExam query:nil path:nil body:@{@"exam_id":exam_id} success:^(id object) {
        [weakSelf hudclose];
        AEExamAnalyzeVC * VC = [AEExamAnalyzeVC new];
        VC.examId = exam_id;
        [weakSelf.navigationController pushViewController:VC animated:YES];
        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
//MARK: initUI
- (void)createMainContentView {
    [self.view addSubview:self.timerView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.bottomView];
    AEExamQuestionItem * item = self.dataSourceArr[0];
    [_contentView refreshData:item];
    WS(weakSelf)
    self.bottomView.block = ^(BOOL isNext,UIButton * nextBtn) {
        //下一题 上一题
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.contentView scrollQuestion:isNext lastHandle:^(BOOL last, int index) {
                [nextBtn setTitle:last ? @"交卷" : @"下一题" forState:UIControlStateNormal];
            }];
        });
    };
    self.contentView.didScrollePage = ^(int page) {
        weakSelf.timerView.examNumLabel.text = [NSString stringWithFormat:@"%d / %ld",page,item.question.count];
    };
    _contentView.submitExamBlock = ^{
        [weakSelf submitTest];
    };
}
- (AEExamTimeView *)timerView {
    if (!_timerView) {
        _timerView = [[NSBundle mainBundle]loadNibNamed:@"AEExamTimeView" owner:nil options:nil].firstObject;
        _timerView.frame = CGRectMake(0, ySpace, SCREEN_WIDTH, timeViewHeight);
        ySpace += timeViewHeight;
    }
    return _timerView;
}

-(AEExamContentView *)contentView {
    if (!_contentView) {
        _contentView = [[AEExamContentView alloc]initWithFrame:CGRectMake(0, ySpace, SCREEN_WIDTH, SCREEN_HEIGHT - bottomViewHeight - ySpace)];
    }
    return _contentView;
}
-(AEExamBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle]loadNibNamed:@"AEExamBottomView" owner:nil options:nil].firstObject;
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - bottomViewHeight, SCREEN_WIDTH, bottomViewHeight);
    }
    return _bottomView;
}
-(NSMutableArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}
-(AETimerHelper *)timer {
    if (!_timer) {
        _timer = [AETimerHelper new];
    }
    return _timer;
}
//- (NSArray <UIBarButtonItem *>*)createCustomBarButtons{
//    //隐藏答题卡
////    ,[AEBase createCustomBarButtonItem:self action:@selector(gotoAnswerCard) image:@"answerCard"]
//    return @[[[UIBarButtonItem alloc]initWithCustomView:self.timerLabel]];
//}
- (void)gotoAnswerCard {
    if (self.dataSourceArr.count <= 0) {
        [AEBase alertMessage:@"没有考题内容，请返回刷新考题" cb:nil];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController pushViewController:self.answerCardVC animated:YES];
}
-(AEAnswerCardVC *)answerCardVC {
    if (!_answerCardVC) {
        _answerCardVC = [AEAnswerCardVC new];
    }
    _answerCardVC.paperData = self.dataSourceArr;
    return _answerCardVC;
}

- (void)backAction:(UIButton *)sender {
    if (self.dataSourceArr.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"考试中途退出之后可以继续考试，但一天以内继续考试有效，超过一天未继续考试，系统自动交卷~" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"继续考试" style:UIAlertActionStyleDefault handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"退出考试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        //应该摧毁定时器 避免浪费资源
        [self.timer destoryTimer];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//顶部导航
- (void)topNavtiation {
    [self.view addSubview:self.baseTopView];
    self.baseTopView.titleName = @"开始考试";
    self.baseTopView.imageViewName = @"exam_top_banner";
    WS(weakSelf)
    self.baseTopView.backBlock = ^{
        [weakSelf backAction:nil];
    };
}






















@end
