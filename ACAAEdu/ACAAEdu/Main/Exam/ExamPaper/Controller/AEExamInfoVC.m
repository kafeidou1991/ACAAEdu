//
//  AEExamInfoVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/11/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamInfoVC.h"

@interface AEExamInfoVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@end

@implementation AEExamInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //顶部导航
    [self topNavtiation];
}



//顶部导航
- (void)topNavtiation {
    [self.view addSubview:self.baseTopView];
    self.baseTopView.titleName = @"开始考试";
    self.baseTopView.imageViewName = @"exam_top_banner";
    self.topConstraint.constant = ySpace;
}

@end
