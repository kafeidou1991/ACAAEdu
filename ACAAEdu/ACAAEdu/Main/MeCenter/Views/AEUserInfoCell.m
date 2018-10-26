//
//  AEUserInfoCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/23.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEUserInfoCell.h"

@implementation AEUserInfoCell

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
    self.contentTextField.text = dict[@"value"];
    self.leftImageView.hidden = STRISEMPTY(dict[@"value"]);
}

@end
