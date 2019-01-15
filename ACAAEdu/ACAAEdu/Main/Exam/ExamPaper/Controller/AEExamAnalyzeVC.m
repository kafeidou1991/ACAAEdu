//
//  AEExamInfoVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/11/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamAnalyzeVC.h"
#import "CircleView.h"
#import "AEMyTestExamVC.h"

@interface AEExamAnalyzeVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
//考试名称
@property (weak, nonatomic) IBOutlet UILabel *examNameLabel;
//考试时间
@property (weak, nonatomic) IBOutlet UILabel *examTimeLabel;
//得分
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
//准考证号
@property (weak, nonatomic) IBOutlet UILabel *examNoLabel;
//通过状态
@property (weak, nonatomic) IBOutlet UILabel *examStatusLabel;

/*=============================================================*/
//课程类别
@property (weak, nonatomic) IBOutlet UILabel *examCateLabel;
//总共题目
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
//答对题目
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
//进度条
@property (weak, nonatomic) IBOutlet CircleView *circleV;

/*=============================================================*/
//知识点分析
@property (weak, nonatomic) IBOutlet UILabel *examPointLabel;
//建议分析
@property (weak, nonatomic) IBOutlet UILabel *evaluateLabel;



@end

@implementation AEExamAnalyzeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //顶部导航
    [self topNavtiation];
    [self initComponent];
    
}
- (void)initComponent {
    //进度条宽度
    _circleV.strokelineWidth = 3;
}
- (void)backAction:(UIButton *)sender {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[AEMyTestExamVC class]]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kExamResultBack" object:nil];
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)afterProFun {
    WS(weakSelf);
    //获取评价
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kExamEvaluate query:nil path:nil body:@{@"exam_id":self.examId} success:^(id object) {
        [weakSelf hudclose];
        [weakSelf updateData:[AEExamEvaluateItem yy_modelWithJSON:object]];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}

//MARK: 组装数据
- (void)updateData:(AEExamEvaluateItem *)item {
    //第一分区
    self.examNameLabel.text = item.subject_name;
    self.examTimeLabel.text = [NSString stringWithFormat:@"考试时间：%@",[NSString dateToStringFormatter:@"yyyy-MM-dd HH:mm" date:[NSDate dateWithTimeIntervalSince1970:item.exam_time.integerValue]]];
    self.scoreLabel.text = [NSString stringWithFormat:@"分数：%@",[NSString stringWithFormat:@"%@/%@",item.total_score,item.paper_score]];
    self.examNoLabel.text = [NSString stringWithFormat:@"准考证号：%@",item.idcard];
    self.examStatusLabel.text = [NSString stringWithFormat:@"状态：%@",item.pass.integerValue == 1 ? @"通过" : @"未通过"];
    
    //第二分区
    if (item.part_info.count > 0) {
        AEExamEvaluateSubItem * subItem = item.part_info[0];
        self.examCateLabel.text = [NSString stringWithFormat:@"课程类别：%@",subItem.part_name];
        self.totalLabel.text = [NSString stringWithFormat:@"题目总数：%@",subItem.part_num];
        self.correctLabel.text = [NSString stringWithFormat:@"答对题目数：%@",subItem.part_correct];
    }
    //设置进度,是否有动画效果
    [self.circleV circleWithProgress:item.rate == 1 ? 100 : (int)item.rate andIsAnimate:YES];
    //第三分区 知识点分析
    if (item.category_info.count > 0) {
        NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc]initWithString:@"" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        for (AEExamKnowPointItem * knowItem in item.category_info) {
            NSAttributedString * temp = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：",knowItem.category] attributes:@{NSForegroundColorAttributeName : AEHexColor(@"E5021B")}];
            [mutableStr appendAttributedString:temp];
            
            NSAttributedString * temp2 = [[NSAttributedString alloc]initWithString:knowItem.diagnose attributes:@{NSForegroundColorAttributeName : AEHexColor(@"999999")}];
            [mutableStr appendAttributedString:temp2];
            
            [mutableStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n\n"]];
        }
        self.examPointLabel.attributedText = mutableStr.copy;
    }else {
        self.examPointLabel.text = @"";
    }
    //第四分区 学习方案
    self.evaluateLabel.text = item.evaluate;
}
//顶部导航
- (void)topNavtiation {
    [self.view addSubview:self.baseTopView];
    self.baseTopView.titleName = @"成绩分析";
    self.baseTopView.imageViewName = @"exam_top_banner";
    self.topConstraint.constant = ySpace - STATUS_BAR_HEIGHT;
}

@end
