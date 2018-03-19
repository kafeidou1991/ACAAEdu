//
//  AEScreeningFooterVIew.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/16.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat footViewHeight = 50.f;
/**
 点击回调

 @param isDone 1确定 0 重置
 */
typedef void(^AEScreeningBlock)(BOOL isDone);

@interface AEScreeningFooterView : UIView

@property (nonatomic, copy) AEScreeningBlock block;

@end
