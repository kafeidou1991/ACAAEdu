//
//  AEOrderPayVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/13.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEOrderPayVC.h"
#import "AEPurchaseManage.h"

@interface AEOrderPayVC ()
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel; //订单信息
@property (weak, nonatomic) IBOutlet UILabel *priceLabel; //总价

@property (nonatomic, strong) AEPurchaseManage * mange; //内购模型
@end

@implementation AEOrderPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单支付";
    
    self.orderNoLabel.text = self.item.orders_no;
    self.priceLabel.text = [NSString stringWithFormat:@"待支付金额:%.2f",self.totalPrice];
    
}

- (IBAction)payAction:(UIButton *)sender {
    //发起支付
    WS(weakSelf)
    [self.mange startPurchWithID:@{@"orders_no":self.item.orders_no,@"price":[NSString stringWithFormat:@"%.2f",self.totalPrice]} completeHandle:^(IAPPurchType type, NSData *data) {
        if (type == kIAPPurchSuccess) {
            //支付成功
            [AEBase alertMessage:@"购买成功" cb:nil];
            //回到根页面
            if (weakSelf.comeType == ComeFromMyOrderType) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kPayOrderSuccess object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        }];
    
    
}


-(AEPurchaseManage *)mange {
    if (!_mange) {
        _mange = [AEPurchaseManage new];
    }
    return _mange;
}


@end
