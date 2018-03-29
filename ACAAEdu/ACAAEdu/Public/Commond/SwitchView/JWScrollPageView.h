//
//  JWScrollPageView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScrollPageViewDelegate <NSObject>
/**
 换页
 @param aPage 当前页
 */
-(void)didScrollPageViewChangedPage:(NSInteger)aPage;
/**
 开始滚动
 @param aPage 当前页
 */
-(void)scrollViewWillBeginPage:(NSInteger)aPage;
@end

@interface JWScrollPageView : UIView


@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *contentItems;
@property (nonatomic,assign) id<ScrollPageViewDelegate> delegate;
/**
 添加ScrollowViewd的ContentView

 @param aNumerOfTables content
 */
-(void)setContentOfTables:(NSInteger)aNumerOfTables;
/**
 滑动到某个页面

 @param aIndex 索引
 */
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex;
/**
 刷新某个页面

 @param aIndex 索引
 */
-(void)freshContentTableAtIndex:(NSInteger)aIndex;

@end
