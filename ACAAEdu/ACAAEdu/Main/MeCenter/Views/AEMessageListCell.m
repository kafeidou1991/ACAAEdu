//
//  AEMessageListCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/16.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMessageListCell.h"

@interface AEMessageListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;  //左部image
@property (weak, nonatomic) IBOutlet UIView *redView; //小红点

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel; //主标题
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel; //副标题
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //标题时间


@end


@implementation AEMessageListCell

- (void)updateCell:(AEMessageList *)item {
    //0 未读 1 已读
    self.leftImageView.image = [UIImage imageNamed:[item.status isEqualToString:@"0"] ? @"notice_unRead":@"notice_read"];
    self.redView.hidden = [item.status isEqualToString:@"1"];
    self.mainTitleLabel.text = item.title;
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:item.create_time.integerValue]ff_dateDescription];
    self.subTitleLabel.text = item.body;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
