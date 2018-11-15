//
//  AEMyExamCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/11/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyExamCell.h"
#import "AEExamItem.h"

@implementation AEMyExamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateMyTestExamCell:(AEMyExamItem *)item done:(BOOL)done {
    self.nameLabel.text = item.subject.subject_full_name;
    //考试通过 #4ED3C1   未通过 #B778FF  带平分 #FBAC52
    self.statusView.backgroundColor = AEHexColor(@"4ED3C1");
    //考试通过 myexam_pass   未通过 myexam_nopass  带平分 myexam_waite
    self.examRightView.image = [UIImage imageNamed:@"myexam_pass"];
    //通过 未通过  待打分
    self.resultLabel.text = [NSString stringWithFormat:@"考试结果:%@",@"通过"];
     //通过 未通过  待打分
    self.examStatusLabel.text = @"考试通过";
    
}

@end
