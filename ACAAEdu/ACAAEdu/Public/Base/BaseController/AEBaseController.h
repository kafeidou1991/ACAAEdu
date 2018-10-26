//
//  AEBaseController.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEBaseTopView.h"

#define AEBaseTopViewHeight (HOME_INDICATOR_HEIGHT + 107.f)

@interface AEBaseController : UIViewController {
    //y边距，控制subView排布
    CGFloat ySpace;
}
/**
 于加载网络请求方法
 */
- (void)afterProFun;

/**
 自定义导航视图
 */
@property (nonatomic, strong) AEBaseTopView * baseTopView;



/**
 需要点击返回时做些功作,在子类实现这个方法,并且自己调用popViewControllerAnimated方法,
 否则不要实现;

 @param sender button
 */
- (void)backAction:(UIButton *)sender;

/**
 开启当前加载

 @param inView 当前view
 @param msgText 信息
 */
- (void)hudShow:(UIView *)inView msg:(NSString *)msgText;
/**
 关闭加载
 */
- (void)hudclose;

/**
 添加子view
 */
- (void)addSubViews;

@end
