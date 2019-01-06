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
#import "AEMyTestExamVC.h"

@interface AEOrderDetailVC ()
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
/// q我要测试
@property (weak, nonatomic) IBOutlet UIButton *toTestBtn;
//去支付
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation AEOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //顶部导航 暂时隐藏
//    self.navigationItem.leftBarButtonItems = @[[AEBase createCustomBarButtonItem:self action:nil image:@"navtaion_topstyle"],[AEBase createCustomBarButtonItem:self action:nil title:@"订单确认"]];
    self.title = _payStatus == AEOrderAffirmPay ? @"订单确认" : @"订单详情";
    [self initContent];
}
- (void)initContent {
    
    //状态
    if (_payStatus != AEOrderAffirmPay) {
        self.payStatusLabel.text = _payStatus == AEOrderPaidStatus ? @"已付款" : @"待付款";
        //我要测试
        self.toTestBtn.backgroundColor = _payStatus == AEOrderPaidStatus ? AEThemeColor : AEHexColor(@"B2B3B4");
    }else {
        self.payStatusLabel.text = @"";
        //我要测试
        self.toTestBtn.hidden = YES;
    }
    //类别 名称 版本
    self.orderNameLabel.text = _item.subject_full_name;
    self.versionLabel.text = [NSString stringWithFormat:@"版本:%@",_item.version];
    self.cateLabel.text = [NSString stringWithFormat:@"类别:%@",_item.subject_type_name];
    //价格
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@",_item.subject_realPrice];
    //原价
    NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价 ￥%@",_item.subject_price] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName:AEHexColor(@"999999"),NSStrikethroughStyleAttributeName : @1}];
    self.orginPriceLabel.attributedText = att;
    
    if (_payStatus == AEOrderPayingStatus || _payStatus == AEOrderAffirmPay) {
        //应付
        self.payLabel.text = _item.subject_realPrice;
        //优惠
        self.discountsLabel.text = _item.subject_discount;
        
        [self.submitBtn setTitle:_payStatus == AEOrderPayingStatus ? @"立即支付" : @"提交订单" forState:UIControlStateNormal];
        
    }else {
        self.bottmOrderView.hidden = YES;
    }
}
//MARK:购买考试
- (void)buyExam {
    WS(weakSelf)
    [self createOrderDetailSuccess:^(AEMyOrderList *item) {
        //pay_status ==0 继续购买  ==1 说明是价格0  直接购买成功
        if ([item.pay_status isEqualToString:@"0"]) {
            AEOrderPayVC * VC = [AEOrderPayVC new];
            VC.item = item;
            VC.totalPrice = weakSelf.item.subject_realPrice.floatValue;
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
    NSArray * paramArray = @[@{@"goods_type":@"subject",@"goods_id":_item.examId,@"goods_num":@"1"}];
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
//MARK: 我要测试
- (IBAction)toTestAction:(UIButton *)sender {
    if (_payStatus == AEOrderPaidStatus) {
         PUSHCustomViewController([AEMyTestExamVC new], self);
    }
    
}

@end
