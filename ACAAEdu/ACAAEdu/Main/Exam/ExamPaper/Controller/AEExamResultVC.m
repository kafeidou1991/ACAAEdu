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

static NSString * const firstSectionReuseIdentifier = @"firstSectionReuseIdentifier";
static NSString * const secondSectionReuseIdentifier = @"secondSectionReuseIdentifier";
static NSString * const thirdSectionReuseIdentifier = @"thirdSectionReuseIdentifier";
static NSString * const fourSectionReuseIdentifier = @"fourSectionReuseIdentifier";

@interface AEExamResultVC ()

@property (nonatomic, strong) AEExamResultCell *prototypeCell; //错题分析

@property (nonatomic, strong) AEExamResultCell *knowPointCell; //知识点分析



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
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
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
    //第三分区 错题分析
    [self.dataSources addObject:@[@{@"title":@"错题分析:",@"content":item.evaluate}]];
    
    //第四分区 知识点分析
    if (item.category_info.count > 0) {
        [self.dataSources addObject:item.category_info];
    }else {
        [self.dataSources addObject:@[]];
    }
    
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
        self.prototypeCell.contentLabel.text = dict[@"content"];
        CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1  + size.height;
    }else if (indexPath.section == 3){
        AEExamKnowPointItem * item = self.dataSources[indexPath.section][indexPath.row];
        //自动计算高度
        self.knowPointCell.contentLabel.text = item.diagnose;
        CGSize size = [self.knowPointCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1  + size.height;
    }else {
        return 30.f;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEExamResultCell * cell = [self createCellWithNibIndex:indexPath.section];
    
    if (indexPath.section == 1) {
        cell.contentLabel.font = [UIFont systemFontOfSize:indexPath.row == 0 ? 20: 14];
    }else if (indexPath.section == 2) {
        cell.contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - cell.titleLabel.right - 5 - 16;
        self.prototypeCell = cell;
    }else if (indexPath.section == 3) {
        cell.contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - cell.titleLabel.right - 5 - 16;
        self.knowPointCell = cell;
    }
    if (indexPath.section == 3) {
        AEExamKnowPointItem * item = self.dataSources[indexPath.section][indexPath.row];
        [cell updateCellKnowPointCell:item];
    }else {
        NSDictionary * dict = self.dataSources[indexPath.section][indexPath.row];
        [cell updateCell:dict];
    }
    return cell;
}
- (AEExamResultCell *)createCellWithNibIndex:(NSInteger)index {
    NSString * identifier;
    switch (index) {
        case 0:
            identifier = firstSectionReuseIdentifier;
            break;
        case 1:
            identifier = secondSectionReuseIdentifier;
            break;
        case 2:
            identifier = thirdSectionReuseIdentifier;
            break;
        case 3:
            identifier = fourSectionReuseIdentifier;
            break;
        default:
            break;
    }
    AEExamResultCell * cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray * array = [[NSBundle mainBundle]loadNibNamed:@"AEExamResultCell" owner:nil options:nil];
        cell =array[index];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.dataSources.count - 1 ? 0.f: 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.dataSources.count - 1) {
        return [UIView new];
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor whiteColor];
    UIView * lion = [[UIView alloc]initWithFrame:CGRectMake(16, 4.5, SCREEN_WIDTH - 2 * 16, 1)];
    lion.backgroundColor = AEColorLine;
    [view addSubview:lion];
    return view;
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
