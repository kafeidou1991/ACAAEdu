//
//  AEMessageListCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/16.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMessageListCell.h"

@interface AEMessageListCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;  //左部title
@property (weak, nonatomic) IBOutlet UIView *redView; //小红点

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel; //主标题
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel; //副标题
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //标题时间


@end


@implementation AEMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
