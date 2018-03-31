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
    AEExamQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AEExamQuestionCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCell:self.result index:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //单选题  单选直接覆盖答案 答案的逻辑是 如果选择A B C D 对应服务器需要传1 2 3 4
    AEExamQuestionCell * lastCell = [self getLastAnswerCell];
    AEExamQuestionCell * cell = (AEExamQuestionCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (lastCell && lastCell != cell) {
        [lastCell select:NO];
    }
    [cell select:YES];
    //索引从0开始的 答案需要加1
    self.result.answer = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kSubmitQuestion query:nil path:nil body:@{@"part_id":self.result.part_id,@"sheet_id":self.result.sheet_id,@"answer":self.result.answer} success:^(id object) {
        NSLog(@"提交答案成功");
    } faile:^(NSInteger code, NSString *error) {
        
        [AEBase alertMessage:error cb:nil];
    }];
    
}
- (AEExamQuestionCell *)getLastAnswerCell {
    if (STRISEMPTY(self.result.answer)) {
        return nil;
    }else {
        return (AEExamQuestionCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.result.answer.integerValue - 1 inSection:0]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //自动计算高度
    AEExamQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AEExamQuestionCell class])];
    cell.questionLabel.text = self.result.result[indexPath.row];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //动态计算行高
    CGFloat leftMargin = 8;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    view.backgroundColor = AEColorBgVC;
    UILabel * titleLabel = [AEBase createLabel:CGRectMake(leftMargin, leftMargin, view.width - 2 * leftMargin, view.height) font:[UIFont systemFontOfSize:15] text:self.result.question defaultSizeTxt:nil color:AEThemeColor backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    [view addSubview:titleLabel];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat leftMargin = 8;
    CGSize size = STR_FONT_SIZE(self.result.question, SCREEN_WIDTH - 2 * leftMargin, [UIFont systemFontOfSize:15]);
    return size.height + 2 * leftMargin;
}






@end
