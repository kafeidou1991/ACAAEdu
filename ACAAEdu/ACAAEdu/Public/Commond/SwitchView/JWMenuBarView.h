//
//  JWMenuBarView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置的key
#define NOMALKEY   @"normalKey"
#define HEIGHTKEY  @"helightKey"
#define TITLEKEY   @"titleKey"
#define TITLEWIDTH @"titleWidth"
#define TOTALWIDTH @"totalWidth"

#define STRING_FONT_SIZE(str,font) [str sizeWithAttributes: @{NSFontAttributeName:font}]

@protocol MenuBarViewDelegate <NSObject>

@optional
-(void)clickMenuBarViewButtonAtIndex:(NSInteger)aIndex;
@end

@interface JWMenuBarView : UIView

#pragma mark 初始化菜单
/**
 初始化方法

 @param frame frame
 @param titles 显示的title数组
 @return nil
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
/**
 选中某个menu

 @param aIndex 索引
 */
-(void)clickMenuAtIndex:(NSInteger)aIndex;
/**
 跳转menu为选中状态

 @param aIndex 索引
 */
-(void)changeMenuStateAtIndex:(NSInteger)aIndex;
/**
 代理方法
 */
@property (nonatomic,assign) id <MenuBarViewDelegate> delegate;

@end
