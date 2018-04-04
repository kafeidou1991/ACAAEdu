//
//  AEExamContentCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamContentCell.h"
#import "AEExamQuestionCell.h"
#import "AEQuestionHeaderVIew.h"

@interface AEExamContentCell () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AEQuestionRresult * result;

@property (nonatomic, strong) NSMutableArray * dataSources;

@property (nonatomic, strong)AEQuestionHeaderVIew * headQuestionView;


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
    //更新头部题干
    [self.dataSources removeAllObjects];
    //更新题干数据
    [self updateHeadView];
    //组装数据
    [self sortData];
    [self.tableView reloadData];
}
- (void)updateHeadView {
    NSMutableArray * titleArray = @[].mutableCopy; NSMutableArray * imageArray = @[].mutableCopy;
    [self.result.question enumerateObjectsUsingBlock:^(AEQuestionSubItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.type isEqualToString:@"img"]) {
            [imageArray addObject:obj];
        }else {
            [titleArray addObject:obj];
        }
    }];
    //存在图片 启动图片下载
    if (imageArray.count > 0) {
        [imageArray enumerateObjectsUsingBlock:^(AEQuestionSubItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self downQuestion:obj.content completed:^(UIImage * image) {
                obj.image = image;
                self.headQuestionView.questionData = self.result.question;
                self.tableView.tableHeaderView =  self.headQuestionView;
            }];
        }];
    }else {
        //没有图片直接加载
        self.headQuestionView.questionData = self.result.question;
        self.tableView.tableHeaderView =  self.headQuestionView;
    }
}
- (void)sortData {
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
    }else{
        //多选
        if (!STRISEMPTY(self.result.answer)) {
            NSArray * array = [self.result.answer componentsSeparatedByString:@","];
            for (NSString * s in array) {
                AEResultItem * item = self.dataSources[s.integerValue - 1];
                item.isSelect = YES;
            }
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEExamQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AEExamQuestionCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCell:self.dataSources[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //第三方要求不需要显示是否单选还是多选，去除单选的限制
    //多选题
    AEExamQuestionCell * cell = (AEExamQuestionCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectBtn.selected = !cell.selectBtn.isSelected;
    AEResultItem * temp = self.dataSources[indexPath.row];
    temp.isSelect = cell.selectBtn.isSelected;
    
    //统计全部已选的cell
    NSMutableString * answerString = @"".mutableCopy;
    NSInteger i = 0;
    for (AEResultItem * item in self.dataSources) {
        if (item.isSelect) {
            [answerString appendFormat:@"%ld,",i + 1];
        }
        i++;
    }
    if ([answerString hasSuffix:@","]) {
        answerString = [answerString substringToIndex:answerString.length - 1].mutableCopy;
    }
    self.result.answer = answerString;
    /*
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
        cell.selectBtn.selected = !cell.selectBtn.isSelected;
        AEResultItem * temp = self.dataSources[indexPath.row];
        temp.isSelect = cell.selectBtn.isSelected;
        
        //统计全部已选的cell
        NSMutableString * answerString = @"".mutableCopy;
        NSInteger i = 0;
        for (AEResultItem * item in self.dataSources) {
            if (item.isSelect) {
                [answerString appendFormat:@"%ld,",i + 1];
            }
            i++;
        }
        if ([answerString hasSuffix:@","]) {
            answerString = [answerString substringToIndex:answerString.length - 1].mutableCopy;
        }
        self.result.answer = answerString;
    }
     */
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

-(AEQuestionHeaderVIew *)headQuestionView {
    if (!_headQuestionView) {
        _headQuestionView = [AEQuestionHeaderVIew new];
        _headQuestionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    }
    return _headQuestionView;
}
-  (void)downQuestion:(NSString *)url completed:(void(^)(UIImage *))hander{
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        hander(image);
    }];
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
////    NSArray * array = [self.result.question matchTextImageMix];
////    NSLog(@"-----------%@",array);
//    //动态计算行高
//    CGFloat leftMargin = 8;
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    UILabel * titleLabel = [AEBase createLabel:CGRectMake(leftMargin, leftMargin, view.width - 2 * leftMargin, view.height) font:[UIFont systemFontOfSize:15] text:self.result.question defaultSizeTxt:nil color:AEThemeColor backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
//    titleLabel.numberOfLines = 0;
//    [titleLabel sizeToFit];
//    [view addSubview:titleLabel];
//    return view;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    CGFloat leftMargin = 8;
//    CGSize size = STR_FONT_SIZE(self.result.question, SCREEN_WIDTH - 2 * leftMargin, [UIFont systemFontOfSize:15]);
//    return size.height + 2 * leftMargin;
//}






@end
