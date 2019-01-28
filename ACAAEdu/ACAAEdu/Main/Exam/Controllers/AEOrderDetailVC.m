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
//提交订单
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

//支付底部提交订单
@property (weak, nonatomic) IBOutlet UIView *bottomSubmitView;
/// 删除订单
@property (weak, nonatomic) IBOutlet UIButton *deleteOrderBtn;
//立即支付
@property (weak, nonatomic) IBOutlet UIButton *payNowBtn;
//左边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceContraint;


@end

@implementation AEOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _payStatus == AEOrderAffirmPay ? @"订单确认" : @"订单详情";
    [self initContent];
}
- (void)setOrderList:(AEMyOrderList *)orderList {
    _orderList = orderList;
    if (orderList.goods.count > 0) {
        AEGoodItem * good = self.orderList.goods[0];
        AEExamItem * goodItem = good.goods_attr_data;
        self.item = goodItem;
        self.item.subject_full_name = good.goods_name;
    }
}
//MARK: 初始化订单数据
- (void)initContent {
    //状态
    if (_payStatus == AEOrderAffirmPay) {
        self.payStatusLabel.text = @"";
        self.toTestBtn.hidden = YES;
    }else if (_payStatus == AEOrderPayingStatus) {
        self.payStatusLabel.text =  @"待付款";
        self.toTestBtn.hidden = YES;
    }else {
        self.payStatusLabel.text =  @"已付款";
        //我要测试
        self.toTestBtn.backgroundColor = AEThemeColor;
    }
    //名称
    self.orderNameLabel.text = _item.subject_full_name;
    //类别 名称 版本
    self.versionLabel.text = [NSString stringWithFormat:@"版本:%@",_item.version];
    self.cateLabel.text = [NSString stringWithFormat:@"类别:%@",_item.subject_type_name];
    //价格
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@",_item.subject_realPrice];
    //原价
    NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价 ￥%@",_item.subject_price] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName:AEHexColor(@"999999"),NSStrikethroughStyleAttributeName : @1}];
    self.orginPriceLabel.attributedText = att;
    
    
    if (_payStatus == AEOrderAffirmPay) {
        //确认订单
        self.bottmOrderView.hidden = NO;
        self.bottomSubmitView.hidden = YES;
        //应付
        self.payLabel.text = _item.subject_realPrice;
        //优惠
        self.discountsLabel.text = _item.subject_discount;
    }else {
        //名称
        self.orderNameLabel.text = _item.subject_full_name;
        self.bottmOrderView.hidden = YES;
        self.bottomSubmitView.hidden = _payStatus == AEOrderPaidStatus;  //已支付 不显示删除订单
//        if (_payStatus == AEOrderPaidStatus) { //已支付 不显示删除订单
//            self.payNowBtn.hidden = YES;
//            self.leftSpaceContraint.constant = SCREEN_WIDTH /2;
//        }
    }
}
//MARK: 提交订单 逻辑更改 新增游客模式登录，游客仅可以进行考试
- (IBAction)submitOrderAction:(UIButton *)sender {
    
    if (User.isLogin) {
        [self buyExam];
    }else {
        [self visitorLogin];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:kPayOrderSuccess object:nil];
            if (weakSelf.comeType == ComeFromMyOrderType) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }];
}
//MARK: 游客购买登录
- (void)visitorLogin {
    WS(weakSelf)
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"购买提示" message:@"请选择登录购买，在其他iOS设备上也可以参加考试，游客购买只能在本台iOS设备参加考试。" preferredStyle:UIAlertControllerStyleAlert];
    //本地登录
    UIAlertAction * loginAction = [UIAlertAction actionWithTitle:@"登录购买(推荐)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AELoginVC OpenLogin:self callback:^(BOOL compliont) {
            if (compliont) {
                [weakSelf buyExam];
            }
        }];
    }];
    [loginAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    [alertVC addAction:loginAction];
    
    //游客登录
    UIAlertAction * visitorAction = [UIAlertAction actionWithTitle:@"游客购买(仅限本设备)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [visitorAction setValue:AEHexColor(@"999999") forKey:@"titleTextColor"];
    [alertVC addAction:visitorAction];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不购买" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//MARK: 创建订单
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
//MARK: 删除订单
- (IBAction)deleteAction:(UIButton *)sender {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要删除此订单么？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WS(weakSelf);
        [self hudShow:self.view msg:@"生成删除.."];
        [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kDeleteOrder query:nil path:nil body:@{@"orders_no" : self.orderList.orders_no} success:^(id object) {
            [weakSelf hudclose];
            [AEBase alertMessage:@"删除成功" cb:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:kOrderDeleteSuccess object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } faile:^(NSInteger code, NSString *error) {
            [weakSelf hudclose];
            [AEBase alertMessage:error cb:nil];
        }];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//MARK: 立即支付 未支付订单
- (IBAction)payNowAction:(UIButton *)sender {
    //未支付的订单不需要创建订单 直接跳转支付页面
    AEOrderPayVC * VC = [AEOrderPayVC new];
    VC.item = self.orderList;
    if (self.orderList.goods.count > 0) {
        AEGoodItem * good = self.orderList.goods[0];
        //因为服务端没有赋值id 此处手动赋值
        AEExamItem * goodItem = good.goods_attr_data;
        VC.totalPrice = goodItem.subject_realPrice.floatValue;
    }
    VC.comeType = self.comeType;
    [self.navigationController pushViewController:VC animated:YES];
}

//MARK: 我要测试
- (IBAction)toTestAction:(UIButton *)sender {
    if (_payStatus == AEOrderPaidStatus) {
         PUSHCustomViewController([AEMyTestExamVC new], self);
    }
    
}

@end
