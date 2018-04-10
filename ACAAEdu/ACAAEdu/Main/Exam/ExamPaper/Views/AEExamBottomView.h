//
//  AEExamBottomView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/4.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HandleBlock)(BOOL isNext, UIButton * nextBtn);

@interface AEExamBottomView : UIView

@property (nonatomic, copy) HandleBlock block;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
