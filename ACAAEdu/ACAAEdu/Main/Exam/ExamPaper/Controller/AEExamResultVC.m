//
//  AEExamResultVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/31.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamResultVC.h"
#import "AECustomSegmentVC.h"
#import "AEExamResultCell.h"
#import "AEExamResultSecondCell.h"

@interface AEExamResultVC ()

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
    self.title = @"成绩分析";
    [self createTableViewStyle:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
}
-(void)afterProFun {
    WS(weakSelf);
    //获取评价
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kExamEvaluate query:nil path:nil body:@{@"exam_id":self.examId} success:^(id object) {
        [weakSelf hudclose];
        [weakSelf updateData:[AEExamEvaluateItem yy_modelWithJSON:object]];
//        [weakSelf updateViewData];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
- (void)updateViewData {
    //    self.examNameLabel.text = self.item.subject_name;
    //    self.examTimeLabel.text = [NSString dateToStringFormatter:@"yyyy-MM-dd HH:mm" date:[NSDate dateWithTimeIntervalSinceNow:self.item.exam_time.integerValue]];
    //    self.idcardLabel.text = self.item.idcard;
    //    self.statusLabel.text = self.item.pass.integerValue == 1 ? @"通过" : @"未通过";
    //    self.scoreLabel.text = [NSString stringWithFormat:@"%@/%@",self.item.total_score,self.item.paper_score];
    //    if (self.item.part_info.count > 0) {
    //        AEExamEvaluateSubItem * subItem = self.item.part_info[0];
    //        self.totalQuesLabel.text = subItem.part_num;
    //        self.getScoreLabel.text = subItem.part_correct;
    //        self.rateLabel.text = subItem.part_passrate.integerValue == 1 ? @"100%" : [NSString stringWithFormat:@"%.2g%%",subItem.part_passrate.floatValue * 100.f];
    //    }
    //    self.evaluateLabel.text = self.item.evaluate;
    //    [self.evaluateLabel sizeToFit];
    //    //不要超出屏幕
    //    self.bgViewHeightContrain.constant = MIN(SCREEN_HEIGHT - NAVIGATION_HEIGHT - 20 * 2, self.evaluateLabel.bottom + 15.f);
    
    
}
//MARK: 组装数据
- (void)updateData:(AEExamEvaluateItem *)item {
    [self.dataSources removeAllObjects];
    //第一分区
    NSArray * arr1 = @[@{@"title":@"考试科目:",@"content":item.subject_name},
                       @{@"title":@"考试时间:",@"content":[NSString dateToStringFormatter:@"yyyy-MM-dd HH:mm" date:[NSDate dateWithTimeIntervalSinceNow:item.exam_time.integerValue]]},
                       @{@"title":@"准考证号:",@"content":item.idcard},
                       @{@"title":@"考试状态:",@"content":item.pass.integerValue == 1 ? @"通过" : @"未通过"}];
    [self.dataSources addObject:arr1];
    
    //第二分区
    if (item.part_info.count > 0) {
        AEExamEvaluateSubItem * subItem = item.part_info[0];
        NSArray * arr2 = @[@{@"title":@"您的考试成绩总分:",@"content":[NSString stringWithFormat:@"%@/%@",item.total_score,item.paper_score]},
                           @{@"title":@"题目总数:",@"content":subItem.part_num},
                           @{@"title":@"答对总数:",@"content":subItem.part_correct},
                           @{@"title":@"合格率:",@"content":subItem.part_passrate.integerValue == 1 ? @"100%" : [NSString stringWithFormat:@"%.2g%%",subItem.part_passrate.floatValue * 100.f]}];
        [self.dataSources addObject:arr2];
    }else {
        [self.dataSources addObject:@[]];
    }
    //第三分区
    [self.dataSources addObject:@[@{@"title":@"错题分析:",@"content":item.evaluate}]];
    
    //第四分区
    
    [self.tableView reloadData];
}
//MARK: tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSources.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * array = self.dataSources[section];
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        return 30.f;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 40.f;
        }else {
            return 30.f;
        }
    }else if (indexPath.section == 2){
        NSDictionary * dict = self.dataSources[indexPath.section][indexPath.row];
        //自动计算高度
//        [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AEExamResultCell class]) owner:nil options:nil] firstObject];
        AEExamResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AEExamResultCell class])];
        cell.contentLabel.text = dict[@"content"];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1  + size.height;
    }else {
        return 30.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor whiteColor];
    UIView * lion = [[UIView alloc]initWithFrame:CGRectMake(16, 4.5, SCREEN_WIDTH - 2 * 16, 1)];
    lion.backgroundColor = [UIColor redColor];//AEColorLine;
    [view addSubview:lion];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dict = self.dataSources[indexPath.section][indexPath.row];
    if (indexPath.section == 0 || indexPath.section == 2) {
        AEExamResultCell * cell = [AEExamResultCell cellWithTableView:tableView];
        if (dict) {
            cell.titleLabel.text = dict[@"title"];
            cell.contentLabel.text = dict[@"content"];
        }
        return cell;
    }else {
        AEExamResultSecondCell * cell = [AEExamResultSecondCell cellWithTableView:tableView];
        if (dict) {
            cell.contentLabel.font = [UIFont systemFontOfSize:indexPath.row == 0 ? 20: 14];
            cell.titleLabel.text = dict[@"title"];
            cell.contentLabel.text = dict[@"content"];
        }
        return cell;
    }
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
