//
//  AEGoodsBasketView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/8.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEGoodsBasketView.h"

@interface AEGoodsBasketView ()

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation AEGoodsBasketView

//更新款项
-(void)updateGoods:(NSArray *)array {
    //合计
    self.countLabel.text = [NSString stringWithFormat:@"包含：%lu个考试",(unsigned long)array.count];
    self.priceLabel.text = [NSString stringWithFormat:@"合计：￥%@",@"999"];
}
//立即付款
- (IBAction)buyNow:(UIButton *)sender {
}


@end
