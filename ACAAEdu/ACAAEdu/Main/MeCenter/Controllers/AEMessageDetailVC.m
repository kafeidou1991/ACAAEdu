//
//  NoticeDetailController.m
//  YZF
//
//  Created by 张竟巍 on 2017/4/17.
//  Copyright © 2017年 Beijing Yi Cheng Agel Ecommerce Ltd. All rights reserved.
//

#import "AEMessageDetailVC.h"

@interface AEMessageDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@end

@implementation AEMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTopView];
    self.baseTopView.titleName = @"通知详情";
    self.topSpace.constant = AEBaseTopViewHeight;
    self.titleLabel.text = self.item.title;
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:self.item.create_time.integerValue]ff_dateDescription];
    self.contentLabel.text = self.item.body;
}



@end
