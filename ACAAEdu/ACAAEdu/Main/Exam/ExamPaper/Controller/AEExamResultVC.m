//
//  AEExamResultVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/31.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamResultVC.h"
#import "AECustomSegmentVC.h"

@interface AEExamResultVC ()

@property (nonatomic, strong) AEExamEvaluateItem * item;

@property (weak, nonatomic) IBOutlet UILabel *examNameLabel; //考试名称
@property (weak, nonatomic) IBOutlet UILabel *examTimeLabel; //考试时间
@property (weak, nonatomic) IBOutlet UILabel *idcardLabel;//准考证号
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//状态
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;//得分
@property (weak, nonatomic) IBOutlet UILabel *totalQuesLabel;//总题目数
@property (weak, nonatomic) IBOutlet UILabel *getScoreLabel;//获得分数
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;//合格率
@property (weak, nonatomic) IBOutlet UILabel *evaluateLabel;//评价

@property (weak, nonatomic) IBOutlet UIView *bgView; //背景view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightContrain;

@end

@implementation AEExamResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成绩单";
    
}
-(void)afterProFun {
    WS(weakSelf);
    //获取评价
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kExamEvaluate query:nil path:nil body:@{@"exam_id":self.examId} success:^(id object) {
        [weakSelf hudclose];
        weakSelf.item = [AEExamEvaluateItem yy_modelWithJSON:object];
        [weakSelf updateViewData];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}

- (void)updateViewData {
    self.examNameLabel.text = self.item.subject_name;
    self.examTimeLabel.text = [NSString dateToStringFormatter:@"yyyy-MM-dd HH:mm" date:[NSDate dateWithTimeIntervalSinceNow:self.item.exam_time.integerValue]];
    self.idcardLabel.text = self.item.idcard;
    self.statusLabel.text = self.item.pass.integerValue == 1 ? @"通过" : @"未通过";
    self.scoreLabel.text = [NSString stringWithFormat:@"%@/%@",self.item.total_score,self.item.paper_score];
    if (self.item.part_info.count > 0) {
        AEExamEvaluateSubItem * subItem = self.item.part_info[0];
        self.totalQuesLabel.text = subItem.part_num;
        self.getScoreLabel.text = subItem.part_correct;
        self.rateLabel.text = subItem.part_passrate.integerValue == 1 ? @"100%" : [NSString stringWithFormat:@"%.2g%%",subItem.part_passrate.floatValue * 100.f];
    }
    self.evaluateLabel.text = self.item.evaluate;
    [self.evaluateLabel sizeToFit];
    self.bgViewHeightContrain.constant = self.evaluateLabel.bottom + 15.f;
    
}
-(void)backAction:(UIBarButtonItem *)sender {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[AECustomSegmentVC class]]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kExamResultBack" object:nil];
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}




@end
