//
//  AEUserRemarkCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEUserRemarkCell.h"

@implementation AEUserRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCell:(NSDictionary *)dict {
    NSString * title = dict[@"title"];
    self.titleLabel.text = title;
    self.contentTextView.text = dict[@"value"];
}

@end
