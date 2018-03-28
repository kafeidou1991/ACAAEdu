//
//  AEMyOrderHeaderView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyOrderHeaderView.h"
#import "AEOrderLabel.h"

static const CGFloat leftMargin = 16.f;
static const CGFloat topMargin = 5.f;
static const CGFloat labelHeight = 25.f;

@interface AEMyOrderHeaderView ()

@property (nonatomic, strong) AEOrderLabel * orderNoLabel;     //订单编号
@property (nonatomic, strong) AEOrderLabel * orderPriceLabel;  //订单价格
@property (nonatomic, strong) AEOrderLabel * orderTimeLabel;   //订单下单时间
@property (nonatomic, strong) AEOrderLabel * orderTypeLabel;   //订单支付方式
@property (nonatomic, strong) UILabel * orderStatusLabel; //订单支付状态
@property (nonatomic, strong) UIControl * orderStatusControl; //点击付款 或者考试事件
@property (nonatomic, strong) UIView  * lionView;         //订单分割线

@end

@implementation AEMyOrderHeaderView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}


- (void)addSubviews {
    [self addSubview:self.orderNoLabel];
    [self addSubview:self.orderStatusLabel];
    [self addSubview:self.orderStatusControl];
    [self addSubview:self.orderPriceLabel];
    [self addSubview:self.orderTimeLabel];
    [self addSubview:self.orderTypeLabel];
    [self addSubview:self.lionView];
}


- (void)updateContent:(AEMyOrderList *)item{
    [self.orderNoLabel updateTitle:@"订单编号：" content:item.orders_no];
    self.orderStatusLabel.text = [item.pay_status isEqualToString:@"0"] ? @"立即支付" : @"立即考试";//item.pay_status_txt;
    [self.orderPriceLabel updateTitle:@"订单金额：" content:item.pay_price];
    [self.orderTimeLabel updateTitle:@"订单时间：" content:item.create_date];
    [self.orderTypeLabel updateTitle:@"支付方式：" content:item.pay_type_txt];
}
- (void)click {
    if (_clickBlock) {
        _clickBlock();
    }
}

#pragma mark - initCompents
#define LabelWidth (SCREEN_WIDTH - 2 * leftMargin)
- (AEOrderLabel *)orderNoLabel {
    if (!_orderNoLabel) {
        _orderNoLabel = [[AEOrderLabel alloc]initWithFrame:CGRectMake(leftMargin, topMargin, LabelWidth - 50, labelHeight)];
    }
    return _orderNoLabel;
}
- (UILabel *)orderStatusLabel {
    if (!_orderStatusLabel) {
        _orderStatusLabel = [AEBase createLabel:CGRectMake(SCREEN_WIDTH - leftMargin - 70, _orderNoLabel.top, 70, labelHeight) font:[UIFont systemFontOfSize:14] text:@"" defaultSizeTxt:@"" color:AEThemeColor backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentCenter];
    }
    return _orderStatusLabel;
}
- (UIControl *)orderStatusControl {
    if (!_orderStatusControl) {
        _orderStatusControl = [[UIControl alloc]initWithFrame:_orderStatusLabel.frame];
        [_orderStatusControl addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderStatusControl;
}
- (AEOrderLabel *)orderPriceLabel {
    if (!_orderPriceLabel) {
        _orderPriceLabel = [[AEOrderLabel alloc]initWithFrame:CGRectMake(_orderNoLabel.left, _orderNoLabel.bottom, LabelWidth, labelHeight)];
    }
    return _orderPriceLabel;
}
- (AEOrderLabel *)orderTimeLabel {
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[AEOrderLabel alloc]initWithFrame:CGRectMake(_orderNoLabel.left, _orderPriceLabel.bottom,LabelWidth, labelHeight)];
    }
    return _orderTimeLabel;
}
- (AEOrderLabel *)orderTypeLabel {
    if (!_orderTypeLabel) {
        _orderTypeLabel = [[AEOrderLabel alloc]initWithFrame:CGRectMake(_orderNoLabel.left, _orderTimeLabel.bottom,LabelWidth, labelHeight)];
    }
    return _orderTypeLabel;
}

- (UIView *)lionView {
    if (!_lionView) {
        _lionView = [[UIView alloc]initWithFrame:CGRectMake(_orderNoLabel.left, _orderTypeLabel.bottom + 5, LabelWidth, 1)];
        _lionView.backgroundColor = AEColorLine;
    }
    return _lionView;
}





@end
