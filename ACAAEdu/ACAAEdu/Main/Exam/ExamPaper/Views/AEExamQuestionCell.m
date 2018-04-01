//
//  AEExamQuestionCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamQuestionCell.h"



@implementation AEExamQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.questionLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 45 - 5;
}
- (void)updateCell:(AEResultItem *)result {
    self.questionLabel.text = result.answer;
    self.optionLabel.text = [self opationString:result.opation];
    //空串 是没有回答 ， 对应的是 1234
    self.selectBtn.selected = result.isSelect;
    
}
- (void)select:(BOOL)isSelect {
    self.selectBtn.selected = isSelect;
}

- (NSString *)opationString:(NSInteger)index {
    NSArray * optionArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N"];
    return (index > (optionArray.count - 1)) ? @"A" : optionArray[index];
}

- (IBAction)selectAction:(UIButton *)sender {
//    sender.selected = !sender.selected;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
