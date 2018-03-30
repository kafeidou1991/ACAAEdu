//
//  AEExamContentCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamContentCell.h"
#import "AEExamQuestionCell.h"

@interface AEExamContentCell () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AEQuestionRresult * result;

@property (nonatomic, strong) AEExamQuestionCell * cell;

@end

@implementation AEExamContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.tableView registerNib:[UINib nibWithNibName:@"AEExamQuestionCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AEExamQuestionCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
-(void)updateCell:(AEQuestionRresult *)data {
    self.result = data;
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.result.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    AEExamQuestionCell * cell = [AEExamQuestionCell cellWithTableView:tableView];
    AEExamQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AEExamQuestionCell class]) forIndexPath:indexPath];
    cell.questionLabel.numberOfLines = 0;
    cell.questionLabel.text = self.result.result[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEExamQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AEExamQuestionCell class])];
    cell.questionLabel.text = self.result.result[indexPath.row];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    UILabel * titleLabel = [AEBase createLabel:CGRectMake(8, 0, view.width - 2 * 8, view.height) font:[UIFont systemFontOfSize:15] text:@"1.这是一道选择题" defaultSizeTxt:nil color:AEThemeColor backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
    [view addSubview:titleLabel];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.f;
}






@end
