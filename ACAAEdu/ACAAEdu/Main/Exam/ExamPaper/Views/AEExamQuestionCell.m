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
        self.selectImageView.image = [UIImage imageNamed:@"testpaper"];
    }else {
        if (result.answer.integerValue == index + 1) {
            self.selectImageView.image = [UIImage imageNamed:@"testpaper_select"];
        }else {
            self.selectImageView.image = [UIImage imageNamed:@"testpaper"];
        }
    }
}
- (void)select:(BOOL)isSelect {
    self.selectImageView.image = [UIImage imageNamed:isSelect ? @"testpaper_select" : @"testpaper"];
}

- (NSString *)opationString:(NSInteger)index {
    NSArray * optionArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H"];
    return (index > (optionArray.count - 1)) ? @"A" : optionArray[index];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
