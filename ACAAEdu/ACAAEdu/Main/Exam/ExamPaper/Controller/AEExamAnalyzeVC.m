//
//  AEExamInfoVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/11/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamAnalyzeVC.h"
#import "CircleView.h"

@interface AEExamAnalyzeVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet CircleView *circleV; //进度条

@end

@implementation AEExamAnalyzeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //顶部导航
    [self topNavtiation];
    
    //进度条宽度
    _circleV.strokelineWidth = 3;
    
    //设置进度,是否有动画效果
    [_circleV circleWithProgress:54 andIsAnimate:YES];
    
}












//顶部导航
- (void)topNavtiation {
    [self.view addSubview:self.baseTopView];
    self.baseTopView.titleName = @"考题分析";
    self.baseTopView.imageViewName = @"exam_top_banner";
    self.topConstraint.constant = ySpace - STATUS_BAR_HEIGHT;
}

@end
