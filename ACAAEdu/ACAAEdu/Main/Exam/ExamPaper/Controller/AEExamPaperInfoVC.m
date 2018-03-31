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

#define MENUHEIHT 41

@interface AEExamPaperInfoVC ()<MenuBarViewDelegate,ScrollPageViewDelegate>
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
    self.title = @"ACAA考试";//self.examItem.subject_full_name;//@"试卷信息";
    self.navigationItem.rightBarButtonItems = [self createCustomBarButtons];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor redColor];
        [[UIApplication sharedApplication].delegate.window addSubview:btn];
        btn.frame = CGRectMake(100, 100, 100, 100);
        [btn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buy {
//    NSLog(@"%@",self.dataSourceArr);
//    [self.navigationController pushViewController:[AEAnswerCardVC new] animated:YES];
//    mobile/exam/evaluate  kSubmitExam
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kExamEvaluate query:nil path:nil body:@{@"exam_id":@"138"} success:^(id object) {
//        [weakSelf hudclose];
        //            for (UIViewController *viewController in self.navigationController.viewControllers) {
        //                if ([viewController isKindOfClass:[NewCourseViewController class]] ||[viewController isKindOfClass:[CourseTestViewController class]] ||[viewController isKindOfClass:[MytestViewController class]]) {
        //                    [self.navigationController popToViewController:viewController animated:YES];
        //                }
        //            }
        
    } faile:^(NSInteger code, NSString *error) {
//        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
    
}
//MARK: 请求数据
/**
 考试的逻辑是 ：
 先进行开始考试接口，然后返回来 考试id --》 用考试id来请求对应的题型接口也就是部分考题接口 --》然后用题型id 去请求对用的考题展示。。各个部分的考题是区分开的 也是分别计时的，比如单选题跟
 操作题 答题时间独立  时间到 进行交卷
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
//    137 138 self.examItem.id
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kStartExamPaper query:nil path:nil body:@{@"subject_id":@"138"} success:^(id object) {
        AEExamQuestionItem * item = [AEExamQuestionItem yy_modelWithJSON:object];
        if (success) {
            success(item);
        }
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
//获取部分考试题型
- (void)getPartExamPaper:(AEExamQuestionItem *)item{
    WS(weakSelf);
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kPartExamPaper query:@{@"user_exam_id":item.id}.mutableCopy path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        NSMutableArray * tempArr = @[].mutableCopy;
        //剔除status == 2 已考完的考题
        for (AEExamQuestionItem * item in [NSArray yy_modelArrayWithClass:[AEExamQuestionItem class] json:object]) {
            if ([item.status isEqualToString:@"1"]) {
                [tempArr addObject:item];
            }
        }
        if (tempArr.count > 0) {
            //先进行第一部分考试  此时的dataSourceArr 虽然并没有获取到全部试题，但是题型个数已经固定
            weakSelf.dataSourceArr = tempArr.mutableCopy;
            [weakSelf getPartExamQuestionIndex:0];
            //添加视图
            [weakSelf createScrollerMenuView];
            
        }else {
            [AEBase alertMessage:@"暂无试题，请稍后重试" cb:nil];
        }
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
//根据部分题型id  获取试题  index  表示获取试题的是第几个部分
- (void)getPartExamQuestionIndex:(NSInteger)index{
    if (self.dataSourceArr.count <= 0 || index > self.dataSourceArr.count - 1) {
        return;
    }
    AEExamQuestionItem * item = self.dataSourceArr[index];
    WS(weakSelf);
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kPartExamQuestion query:@{@"exam_part_id":item.id}.mutableCopy path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        
        AEExamQuestionItem * item = [AEExamQuestionItem yy_modelWithJSON:object];
        //已经获取到全部试题  可替换数据源
        weakSelf.dataSourceArr[index] = item;
        //刷新试题页面
        [weakSelf refreshExamView:index];
        //开启定时器
        [weakSelf openTimer:item.count_down_time.integerValue];
        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
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
//            weakSelf.navigationItem.rightBarButtonItem = [weakSelf createCustomBarButtonTitle:timeString];
            weakSelf.timerLabel.text = timeString;
        }else {
            //考试结束 应该交卷
        }
    }];
}

//MARK: MenuHrizontalDelegate
- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    [_scrollPageView moveScrollowViewAthIndex:aIndex];
}
-(void)didScrollPageViewChangedPage:(NSInteger)aPage {
    [_menuBarView changeMenuStateAtIndex:aPage];
    
    [_scrollPageView freshContentTableAtIndex:aPage];
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
    _scrollPageView.scrollView.showsHorizontalScrollIndicator = NO;
    for (NSInteger i = 0 ; i<self.dataSourceArr.count; i++) {
        AEExamContentView * view = [[AEExamContentView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i,0, _scrollPageView.width, _scrollPageView.frame.size.height)];
        [_scrollPageView.scrollView addSubview:view];
        [_scrollPageView.contentItems addObject:view];
    }
    [_scrollPageView.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * self.dataSourceArr.count, _scrollPageView.frame.size.height)];
}
- (NSArray *)loadExamData {
//    self.dataSourceArr = @[@{@"type":@"单选题"},@{@"type":@"多选题"},@{@"type":@"判断题"}];
    //组装数据（后期再进行优化）
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:0];
    for (AEExamQuestionItem * item in self.dataSourceArr) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setValue:@"normal.png" forKey:NOMALKEY];
        [dict setValue:@"helight.png" forKey:HEIGHTKEY];
        [dict setValue:item.part_name forKey:TITLEKEY];
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
- (NSArray <UIBarButtonItem *>*)createCustomBarButtons{
    return @[[[UIBarButtonItem alloc]initWithCustomView:self.timerLabel],[AEBase createCustomBarButtonItem:self action:@selector(gotoAnswerCard) image:@"answerCard"]];
}
- (void)gotoAnswerCard {
    if (self.dataSourceArr.count <= 0) {
        [AEBase alertMessage:@"没有考题内容，请返回刷新考题" cb:nil];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    AEAnswerCardVC * answerCardVC = [AEAnswerCardVC new];
    answerCardVC.paperData = self.dataSourceArr;
    [self.navigationController pushViewController:answerCardVC animated:YES];
}
- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [AEBase createLabel:CGRectMake(0, 0, 60, 25) font:[UIFont systemFontOfSize:14.f] text:@"" defaultSizeTxt:nil color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentCenter];
    }
    return _timerLabel;
}
-(void)backAction:(UIBarButtonItem *)sender {
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
