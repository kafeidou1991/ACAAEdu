//
//  AEMyExamCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/11/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyExamCell.h"

@implementation AEMyExamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateMyTestExamCell:(AEMyExamItem *)item{
    self.nameLabel.text = item.subject.subject_full_name;
    //考试通过 myexam_pass   未通过 myexam_nopass  未考试 myexam_waite  考试中 myexam_during
//    1）等待考试；  #FBAC52
//    2）考试中； 暂定项目主题色吧他们没出 #ED2323，显示文案为继续考试
//    3）通过；  #4ED3C1
//    4）未通过。  #B778FF
    self.examRightView.image = [[UIImage imageNamed:@"myexam_waite"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if (item.status.intValue == 0) { //未考试
         self.resultLabel.text = [NSString stringWithFormat:@"考试结果:等待考试"];
         self.examStatusLabel.text = @"等待考试";
         self.statusView.backgroundColor = self.examRightView.tintColor = AEHexColor(@"FBAC52");
    }else if (item.status.intValue == 1) { //考试中
        self.resultLabel.text = [NSString stringWithFormat:@"考试结果:继续考试"];
        self.examStatusLabel.text = @"继续考试";
        self.statusView.backgroundColor = self.examRightView.tintColor = AEHexColor(@"ED2323");
    } else { //完成考试
        self.resultLabel.text = [NSString stringWithFormat:@"考试结果:%@",item.pass == 1 ? @"通过" : @"未通过"];
        self.examStatusLabel.text = @"考试结束";
        self.statusView.backgroundColor = self.examRightView.tintColor = AEHexColor(item.pass == 1 ? @"4ED3C1" : @"B778FF");
    }
}

@end
