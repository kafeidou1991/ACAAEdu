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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
