//
//  AEExamResultCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/12.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamResultCell.h"

@interface AEExamResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *pointNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@end

@implementation AEExamResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(NSDictionary *)dict {
    if (dict) {
        self.titleLabel.text = dict[@"title"];
        self.contentLabel.text = dict[@"content"];
        
    }
}
- (void)updateCellKnowPointCell:(AEExamKnowPointItem *)item {
    self.pointNameLabel.text = item.category;
    self.pointLabel.text = [NSString stringWithFormat:@"%@/%@",item.getpoint,item.point];
    self.contentLabel.text = item.diagnose;
    
}

@end
