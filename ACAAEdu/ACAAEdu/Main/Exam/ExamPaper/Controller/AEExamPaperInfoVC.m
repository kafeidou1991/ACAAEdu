//
//  AEExamPaperInfoVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamPaperInfoVC.h"
#import "AEExamItem.h"
#import "JWMenuBarView.h"
#import "JWScrollPageView.h"
#import "AEExamContentView.h"
#import "AEAnswerCardVC.h"
#import "AEExamResultVC.h"

#define MENUHEIHT 41

@interface AEExamPaperInfoVC ()<MenuBarViewDelegate,ScrollPageViewDelegate,UIScrollViewDelegate>
/**
 题型数组 试题全部数据  因为获取试题接口返回 全部数据，可覆盖部分试题接口返回的数据
 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
/**
 菜单栏
 */
@property (nonatomic, strong) JWMenuBarView * menuBarView;
/**
 滚动区域视图
 */
@property (nonatomic, strong) JWScrollPageView * scrollPageView;
/**
 定时器
 */
@property (nonatomic, strong) AETimerHelper * timer;
/**
 显示倒计时
 */
@property (nonatomic, strong) UILabel * timerLabel;
/**
 答题卡
 */
@property (nonatomic, strong) AEAnswerCardVC * answerCardVC;
/**
 题型
 */
@property (nonatomic, strong) NSArray * questionTypeArray;

@end

@implementation AEExamPaperInfoVC

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
    self.title = @"ACAA考试";
    self.navigationItem.rightBarButtonItems = [self createCustomBarButtons];
    WS(weakSelf)
    self.answerCardVC.selectedBlock = ^(NSIndexPath *indexPath) {
        [weakSelf clickMenuBarViewButtonAtIndex:indexPath.section];
        AEExamContentView * view = weakSelf.scrollPageView.contentItems[indexPath.section];
        dispatch_async(dispatch_get_main_queue(), ^{
           [view scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        });
    };
}

//MARK: 请求数据
/**
 考试的逻辑是 ：
 先进行开始考试接口，然后返回来 考试id --》 用考试id来请求对应的题型接口也就是部分考题接口 值选择part_type== 1的基础题  然后根据type区分多选单选-- 去请求对用的考题展示。。  时间到 进行交卷
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
        for (AEExamQuestionItem * item in [NSArray yy_modelArrayWithClass:[AEExamQuestionItem class] json:object]) {
            if ([item.status isEqualToString:@"1"] && [item.part_type isEqualToString:@"1"]) {
                [tempArr addObject:item];
            }
        }
        if (tempArr.count > 0) {
            //获取第一部分 基础题试题
            [weakSelf getPartExamQuestionIndex:tempArr[0]];
        }else {
            [weakSelf hudclose];
            [AEBase alertMessage:@"该考卷已经考完，请选择其他考卷" cb:nil];
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
        //组装数据
        [self sortData:item];
//        刷新试题页面
//        [weakSelf refreshExamView:index];
        //添加视图
        [weakSelf createScrollerMenuView];
        
        //开启定时器
        [weakSelf openTimer:item.count_down_time.integerValue];
        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
//type 1-判断题2-单选题 3-复选题
- (void)sortData:(AEExamQuestionItem *)item {
    NSMutableArray * signleArray = @[].mutableCopy;
    NSMutableArray * doubleArray = @[].mutableCopy;
    NSMutableArray* judgeArray   = @[].mutableCopy;
    //筛选出来题型然后展示界面
    for (AEQuestionRresult * resutItem in item.question) {
        if ([resutItem.type isEqualToString:@"2"]) {
            [signleArray addObject:resutItem];
        }else if ([resutItem.type isEqualToString:@"3"]) {
            [doubleArray addObject:resutItem];
        }else {
            [judgeArray addObject:resutItem];
        }
    }
    if (signleArray.count > 0) {
        AEExamQuestionItem * signleItem = item.copy;
        signleItem.question = signleArray.copy;
        signleItem.questionName = self.questionTypeArray[0];
        [self.dataSourceArr addObject:signleItem];
    }
    if (doubleArray.count > 0) {
        AEExamQuestionItem * doubleItem = item.copy;
        doubleItem.question = doubleArray.copy;
        doubleItem.questionName = self.questionTypeArray[1];
        [self.dataSourceArr addObject:doubleItem];
    }
    if (judgeArray.count > 0) {
        AEExamQuestionItem * judgeItem = item.copy;
        judgeItem.questionName = self.questionTypeArray[2];
        judgeItem.question = judgeArray.copy;
        [self.dataSourceArr addObject:judgeItem];
    }
    
    
}
//MARK: Private Method
- (void)refreshExamView:(NSInteger)aIndex {
    AEExamContentView * view = _scrollPageView.contentItems[aIndex];
    [view refreshData:self.dataSourceArr[aIndex]];
}
//MARK: 定时器
- (void)openTimer:(NSTimeInterval)countdown {
    WS(weakSelf)
    [self.timer countDownTimeInterval:countdown completeBlock:^(NSString *timeString, BOOL finish) {
        if (!finish) {
            weakSelf.timerLabel.text = timeString;
        }else {
            //考试结束 应该交卷
            [weakSelf timeOutAction];
        }
    }];
}
- (void)timeOutAction {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"交卷" message:@"考试时间已到，请交卷" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"交卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WS(weakSelf);
        [self hudShow:self.view msg:@"正在提交答案..."];
        //每个部分的考试id的一致的，所以取出来一个就可以
        AEExamQuestionItem * item = self.dataSourceArr[0];
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
//MARK: MenuHrizontalDelegate
- (void)clickMenuBarViewButtonAtIndex:(NSInteger)aIndex{
    [_scrollPageView moveScrollowViewAthIndex:aIndex];
}

-(void)didScrollPageViewChangedPage:(NSInteger)aPage {
    [_menuBarView changeMenuStateAtIndex:aPage];
    
}
-(void)scrollViewWillBeginPage:(NSInteger)aPage {
    
}
//MARK: initUI
- (void)createScrollerMenuView {
    //默认选中第一个button
    [self.view addSubview:self.menuBarView]; //题型选择按钮
    [self.menuBarView clickMenuAtIndex:0];
    [self.view addSubview:self.scrollPageView];
}

- (void)setContentTableViews {
    if (self.dataSourceArr.count == 0) {
        return;
    }
    _scrollPageView.scrollView.showsHorizontalScrollIndicator = NO;
    for (NSInteger i = 0 ; i<self.dataSourceArr.count; i++) {
        AEExamQuestionItem * item = self.dataSourceArr[i];
        AEExamContentView * view = [[AEExamContentView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i,0, _scrollPageView.width, _scrollPageView.frame.size.height)];
        view.questionType = [self.questionTypeArray indexOfObject:item.questionName];
        [_scrollPageView.scrollView addSubview:view];
        [_scrollPageView.contentItems addObject:view];
        [view refreshData:item];
    }
    
    [_scrollPageView.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * self.dataSourceArr.count, _scrollPageView.frame.size.height)];
}
- (NSArray *)loadExamData {
    //type 1-判断题2-单选题 3-复选题
//    self.dataSourceArr = @[@{@"type":@"单选题"},@{@"type":@"多选题"},@{@"type":@"判断题"}];
    //组装数据（后期再进行优化）
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:0];
    for (AEExamQuestionItem * item in self.dataSourceArr) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setValue:@"normal.png" forKey:NOMALKEY];
        [dict setValue:@"helight.png" forKey:HEIGHTKEY];
        [dict setValue:item.questionName forKey:TITLEKEY];
//        [dict setValue:[NSNumber numberWithFloat:[dic[@"type"] boundingRectWithSize:CGSizeMake(MAXFLOAT, 30.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size.width+20] forKey:TITLEWIDTH];
        //三等分
        [dict setValue:[NSNumber numberWithFloat:SCREEN_WIDTH/self.dataSourceArr.count] forKey:TITLEWIDTH];
        [buttonArray addObject:dict];
    }
    return buttonArray.copy;
}
-(JWMenuBarView *)menuBarView {
    if (!_menuBarView) {
        _menuBarView = [[JWMenuBarView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, MENUHEIHT) titles:[self loadExamData]];
        _menuBarView.delegate = self;
    }
    return _menuBarView;
}
-(JWScrollPageView *)scrollPageView {
    if (!_scrollPageView) {
        _scrollPageView = [[JWScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - MENUHEIHT)];
        _scrollPageView.delegate = self;
        //添加数据
        [self setContentTableViews];
    }
    return _scrollPageView;
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
-(NSArray *)questionTypeArray {
    if (!_questionTypeArray) {
        _questionTypeArray = @[@"单选题",@"多选题",@"判断题"];
    }
    return _questionTypeArray;
}
- (NSArray <UIBarButtonItem *>*)createCustomBarButtons{
    return @[[[UIBarButtonItem alloc]initWithCustomView:self.timerLabel],[AEBase createCustomBarButtonItem:self action:@selector(gotoAnswerCard) image:@"answerCard"]];
}
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

- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [AEBase createLabel:CGRectMake(0, 0, 60, 25) font:[UIFont systemFontOfSize:14.f] text:@"" defaultSizeTxt:nil color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentCenter];
    }
    return _timerLabel;
}
-(void)backAction:(UIBarButtonItem *)sender {
    if (self.dataSourceArr.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"退出考试?" message:@"退出考试会保存您已答题目的记录" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"退出考试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        //应该摧毁定时器 避免浪费资源
        [self.timer destoryTimer];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
