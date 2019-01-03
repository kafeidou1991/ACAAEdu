//
//  AEOrderDetailVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEOrderDetailVC.h"
#import "AEOrderPayVC.h"
#import "AEExamItem.h"

@interface AEOrderDetailVC ()

@property (nonatomic, assign) CGFloat totalPrice;
//UI元素
//支付状态
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
/// 订单名称
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
//版本
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
//类别
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;
///订单优惠过金额   ￥100
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
/// 订单 原价￥500
@property (weak, nonatomic) IBOutlet UILabel *orginPriceLabel;

///底部提交订单
@property (weak, nonatomic) IBOutlet UIView *bottmOrderView;
///应付金额 500
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
///优惠了多少 400
@property (weak, nonatomic) IBOutlet UILabel *discountsLabel;


@end

@implementation AEOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.leftBarButtonItems = @[[AEBase createCustomBarButtonItem:self action:nil image:@"navtaion_topstyle"],[AEBase createCustomBarButtonItem:self action:nil title:@"订单确认"]];
    self.title = _payStatus == AEOrderPaidStatus ? @"订单详情" : @"订单确认";
    [self initContent];
}
- (void)initContent {
    self.totalPrice = STRISEMPTY(_item.subject_discount) ? _item.subject_price.floatValue : _item.subject_discount.floatValue;
    
    //状态
    self.payStatusLabel.text = _payStatus == AEOrderPaidStatus ? @"已付款" : @"待付款";
    //类别 名称 版本
    self.orderNameLabel.text = _item.subject_name;
    self.versionLabel.text = [NSString stringWithFormat:@"版本:%@",_item.version];
    self.cateLabel.text = [NSString stringWithFormat:@"类别:%@",_item.subject_type_name];
    //价格
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@",_item.subject_discount];
    //原价
    NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价 ￥%@",_item.subject_price] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName:AEHexColor(@"999999"),NSStrikethroughStyleAttributeName : @1}];
    self.orginPriceLabel.attributedText = att;
    
    if (_payStatus == AEOrderPaidStatus) {
        self.bottmOrderView.hidden = YES;
        return;
    }
    //应付
    self.payLabel.text = _item.subject_discount;
    //优惠
    CGFloat price = _item.subject_price.floatValue;
    CGFloat orignPrice = _item.subject_discount.floatValue;
    self.discountsLabel.text = [NSString stringWithFormat:@"%.2f",price - orignPrice > 0 ? price - orignPrice : 0.00];
    
    
}
//MARK:购买考试
- (void)buyExam {
    WS(weakSelf)
    [self createOrderDetailSuccess:^(AEMyOrderList *item) {
        //pay_status ==0 继续购买  ==1 说明是价格0  直接购买成功
        if ([item.pay_status isEqualToString:@"0"]) {
            AEOrderPayVC * VC = [AEOrderPayVC new];
            VC.item = item;
            VC.totalPrice = weakSelf.totalPrice;
            VC.comeType = weakSelf.comeType;
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }else {
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

- (IBAction)submitOrderAction:(UIButton *)sender {
    _payStatus == AEOrderPaidStatus ? nil : [self buyExam];
}

- (void)createOrderDetailSuccess:(void(^)(AEMyOrderList * item))success {
    WS(weakSelf);
    [self hudShow:self.view msg:@"生成订单.."];
    NSArray * paramArray = @[@{@"goods_type":@"subject",@"goods_id":_item.id,@"goods_num":@"1"}];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kCreatOrder query:nil path:nil body:@{@"goods" : paramArray} success:^(id object) {
        [weakSelf hudclose];
        AEMyOrderList * item = [AEMyOrderList yy_modelWithJSON:object];
        if (success) {
            success(item);
        }
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}

@end
