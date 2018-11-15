//
//  AEMyOrderHeaderView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyOrderFooterView.h"
#import "AEOrderLabel.h"

static const CGFloat leftMargin = 16.f;
static const CGFloat topMargin = 5.f;
static const CGFloat labelHeight = 25.f;

@interface AEMyOrderFooterView ()

@property (nonatomic, strong) AEOrderLabel * orderNoLabel;     //订单编号
@property (nonatomic, strong) AEOrderLabel * orderPriceLabel;  //订单价格
@property (nonatomic, strong) AEOrderLabel * orderTimeLabel;   //订单下单时间
@property (nonatomic, strong) AEOrderLabel * orderTypeLabel;   //订单支付方式
@property (nonatomic, strong) AEOrderLabel * orderStatusLabel; //订单状态
@property (nonatomic, strong) UILabel * checkLabel;  //查看详情
@property (nonatomic, strong) UIButton * checkButton; //查看详情

@property (nonatomic, strong) UIView  * lionView;         //订单分割线

@end

@implementation AEMyOrderFooterView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = AEHexColor(@"E4E5E6");
        [self addSubviews];
    }
    return self;
}


- (void)addSubviews {
    [self addSubview:self.orderNoLabel];
    [self addSubview:self.orderTimeLabel];
    [self addSubview:self.orderPriceLabel];
    [self addSubview:self.orderTypeLabel];
    [self addSubview:self.orderStatusLabel];
    [self addSubview:self.checkButton];
    [self addSubview:self.checkLabel];
//    [self addSubview:self.lionView];
}


- (void)updateContent:(AEMyOrderList *)item{
    [self.orderNoLabel updateTitle:@"订单编号：" content:item.orders_no];
//    self.orderStatusLabel.text = [item.pay_status isEqualToString:@"0"] ? @"立即支付" : @"立即考试";//item.pay_status_txt;
    [self.orderTimeLabel updateTitle:@"订单时间：" content:item.create_date];
    [self.orderPriceLabel updateTitle:@"订单金额：" content:[NSString stringWithFormat:@"￥%@",item.pay_price]];
    [self.orderTypeLabel updateTitle:@"支付方式：" content:item.pay_type_txt];
    [self.orderStatusLabel updateTitle:@"订单状态：" content:[item.pay_status isEqualToString:@"0"] ? @"待支付" : @"已支付"];
    
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
- (AEOrderLabel *)orderTimeLabel {
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[AEOrderLabel alloc]initWithFrame:CGRectMake(_orderNoLabel.left, _orderNoLabel.bottom,LabelWidth, labelHeight)];
    }
    return _orderTimeLabel;
}
- (AEOrderLabel *)orderPriceLabel {
    if (!_orderPriceLabel) {
        _orderPriceLabel = [[AEOrderLabel alloc]initWithFrame:CGRectMake(_orderNoLabel.left, _orderTimeLabel.bottom, LabelWidth, labelHeight)];
    }
    return _orderPriceLabel;
}
- (AEOrderLabel *)orderTypeLabel {
    if (!_orderTypeLabel) {
        _orderTypeLabel = [[AEOrderLabel alloc]initWithFrame:CGRectMake(_orderNoLabel.left, _orderPriceLabel.bottom,LabelWidth, labelHeight)];
    }
    return _orderTypeLabel;
}
- (AEOrderLabel *)orderStatusLabel {
    if (!_orderStatusLabel) {
         _orderStatusLabel = [[AEOrderLabel alloc]initWithFrame:CGRectMake(_orderNoLabel.left, _orderTypeLabel.bottom,LabelWidth, labelHeight)];
    }
    return _orderStatusLabel;
}
- (UIButton *)checkButton {
    if (!_checkButton) {
        CGSize size = CGSizeMake(40, 40);
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkButton.frame = CGRectMake(self.width - 16 - size.width, _orderStatusLabel.bottom - labelHeight/2 - size.height/2, size.width, size.height);
        [_checkButton setImage:[UIImage imageNamed:@"check_more"] forState:UIControlStateNormal];
        _checkButton.backgroundColor = AEThemeColor;
        _checkButton.layer.cornerRadius = size.width/2;
        [_checkButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}
- (UILabel *)checkLabel {
    if (!_checkLabel) {
        _checkLabel = [AEBase createLabel:CGRectZero font:[UIFont systemFontOfSize:14] text:@"查看详情" defaultSizeTxt:@"" color:AEHexColor(@"666666") backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentRight];
        [_checkLabel sizeToFit];
        _checkLabel.frame = CGRectMake(_checkButton.left - _checkLabel.width - 5, _orderStatusLabel.top, _checkLabel.width, labelHeight);
    }
    return _checkLabel;
}


- (UIView *)lionView {
    if (!_lionView) {
        _lionView = [[UIView alloc]initWithFrame:CGRectMake(_orderNoLabel.left, _orderTypeLabel.bottom + 5, LabelWidth, 1)];
        _lionView.backgroundColor = AEColorLine;
    }
    return _lionView;
}





@end
