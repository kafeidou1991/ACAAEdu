//
//  AEGoodsBasketView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/8.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BuyNowBlock)(NSArray * );

@interface AEGoodsBasketView : UIView

//刷新数据
- (void)updateGoods:(NSArray *)array;

/**
 立即购买
 */
@property (nonatomic, copy) BuyNowBlock buyNowBlock;

@end
