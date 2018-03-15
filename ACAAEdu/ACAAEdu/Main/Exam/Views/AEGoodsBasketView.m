//
//  AEGoodsBasketView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/8.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEGoodsBasketView.h"
#import "AEExamItem.h"

@interface AEGoodsBasketView ()

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) NSArray * array;
@end

@implementation AEGoodsBasketView

//更新款项
-(void)updateGoods:(NSArray *)array {
    //合计
    self.array = array;
    self.countLabel.text = [NSString stringWithFormat:@"包含：%lu个考试",(unsigned long)array.count];
    CGFloat  price = 0.00;
    for (AEExamItem * item in array) {
        price += item.subject_price.floatValue;
    }
    self.priceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",price];
}
//立即付款
- (IBAction)buyNow:(UIButton *)sender {
    if (_buyNowBlock) {
        _buyNowBlock(self.array);
    }
}


@end
