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

@property (nonatomic, strong) NSMutableArray * dataSources;


@end

@implementation AEExamContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dataSources = @[].mutableCopy;
    [self.tableView registerNib:[UINib nibWithNibName:@"AEExamQuestionCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AEExamQuestionCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = AEColorBgVC;
    
}
-(void)updateCell:(AEQuestionRresult *)data {
    self.result = data;
    [self.dataSources removeAllObjects];
    //因为服务端返回的数据有点问题，自行本地组装数据
    NSInteger i = 0;
    for (NSString * s in self.result.result) {
        AEResultItem * item = [AEResultItem new];
        item.answer = s;
        item.isSelect = NO;
        item.opation = i;
        [self.dataSources addObject:item];
        i++;
    }
    //单选 判断
    if ([self.result.type isEqualToString:@"2"] || [self.result.type isEqualToString:@"1"]) {
        if (!STRISEMPTY(self.result.answer)) {
            AEResultItem * item = self.dataSources[self.result.answer.integerValue - 1];
            item.isSelect = YES;
        }
    }else {
        
    }
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEExamQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AEExamQuestionCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.result.type isEqualToString:@"2"] || [self.result.type isEqualToString:@"1"]) {
//        [cell updateCell:self.result index:indexPath.row];
        [cell updateCell:self.dataSources[indexPath.row]];
    }else {
        [cell updateMoreCell:self.result index:indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    1-判断题 2-单选题 3-复选题 4-匹配题 11-操作题【4暂无】
    if ([self.result.type isEqualToString:@"2"] || [self.result.type isEqualToString:@"1"]) {
        //单选题  单选直接覆盖答案 答案的逻辑是 如果选择A B C D 对应服务器需要传1 2 3 4
        //    索引从0开始的 答案需要加1
        AEExamQuestionCell * lastCell = [self getSignleLastAnswerCell];
        AEExamQuestionCell * cell = (AEExamQuestionCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (lastCell) {
            [lastCell select:NO];
        }
        if (lastCell == cell) {
            //取消选中
            self.result.answer = @"";
            return;
        }
        [cell select:YES];
        //末尾赋值 否则会覆盖
        self.result.answer = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    }else {
        //多选题
        AEExamQuestionCell * cell = (AEExamQuestionCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selectBtn.selected = !cell.selectBtn.selected;
        
        
        
    }
    
    NSLog(@"--------%@------",self.result.answer);
    
    
//    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kSubmitQuestion query:nil path:nil body:@{@"part_id":self.result.part_id,@"sheet_id":self.result.sheet_id,@"answer":self.result.answer} success:^(id object) {
//        NSLog(@"提交答案成功");
//    } faile:^(NSInteger code, NSString *error) {
//
//        [AEBase alertMessage:error cb:nil];
//    }];
    
}
//获取已经选择的
- (AEExamQuestionCell *)getSignleLastAnswerCell {
    if (STRISEMPTY(self.result.answer)) {
        return nil;
    }else {
        return (AEExamQuestionCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.result.answer.integerValue > 0 ? (self.result.answer.integerValue - 1) : 0 inSection:0]];
    }
}
//多选
- (NSArray <AEExamContentCell *> *)getDoubleLastAnswerCell {
    if (STRISEMPTY(self.result.answer)) {
        return nil;
    }else {
        NSMutableArray * tempArray = @[].mutableCopy;
        NSArray * answers = [self.result.answer componentsSeparatedByString:@","];
        for (NSInteger i = 0; i< answers.count; i++) {
            NSString * s = answers[i];
            if (!STRISEMPTY(s)) {
                [tempArray addObject:(AEExamQuestionCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:s.integerValue > 0 ? (s.integerValue - 1) : 0 inSection:0]]];
            }
        }
        return tempArray;
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
