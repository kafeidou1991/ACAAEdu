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

- (void)updateCell:(AEQuestionRresult *)result index:(NSInteger)index {
    self.questionLabel.text = result.result[index];
    self.optionLabel.text = [self opationString:index];
    //空串 是没有回答 ， 对应的是 1234
    if (STRISEMPTY(result.answer)) {
        self.selectBtn.selected = NO;
    }else {
        if (result.answer.integerValue == index + 1) {
            self.selectBtn.selected = YES;
        }else {
            self.selectBtn.selected = NO;
        }
    }
}
- (void)updateCell:(AEResultItem *)result {
    self.questionLabel.text = result.answer;
    self.optionLabel.text = [self opationString:result.opation];
    self.selectBtn.selected = result.isSelect;
    
}
- (void)updateMoreCell:(AEQuestionRresult *)result index:(NSInteger)index {
    self.questionLabel.text = result.result[index];
    self.optionLabel.text = [self opationString:index];
    //空串 是没有回答 ， 对应的是 1,2,3,4
    if (STRISEMPTY(result.answer)) {
        self.selectBtn.selected = NO;
    }else {
        //包含序号 说明是打过的
        if ([result.answer containsString:[NSString stringWithFormat:@"%ld",(index + 1)]]) {
            self.selectBtn.selected = YES;
        }else {
            self.selectBtn.selected = NO;
        }
    }
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
