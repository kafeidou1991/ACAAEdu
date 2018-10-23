//
//  AEBaseTopView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/10/23.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

//自定义导航视图

@interface AEBaseTopView : UIView

/**
 背景图片
 */
@property (nonatomic, copy) NSString *imageViewName;

/**
 标题title
 */
@property (nonatomic, copy) NSString *titleName;

/**
 默认pop返回  实现会滴需要自行处理逻辑
 */
@property (nonatomic, copy) dispatch_block_t backBlock;

@end
