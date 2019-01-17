//
//  HomeHeaderReusableView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMBannerView;

@interface AEHomeHeaderView : UIView

/**
 更新banner数据
 
 @param array banner数组
 */
- (void)updateBanner:(NSArray *)array;

@end
