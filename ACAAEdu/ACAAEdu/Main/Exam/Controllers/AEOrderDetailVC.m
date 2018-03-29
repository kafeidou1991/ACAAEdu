//
//  AEOrderDetailVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEOrderDetailVC.h"
#import "AEOrderDetailCell.h"
#import "AEOrderDetailFooterView.h"
#import "AEOrderPayVC.h"
#import "AEExamItem.h"

@interface AEOrderDetailVC ()
@property (nonatomic, strong) AEOrderDetailFooterView * footerView;

@property (nonatomic, assign) CGFloat totalPrice;

@end

@implementation AEOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"订单详情";
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = self.footerView;
    
}
-(void)createOrderDetailSuccess:(void(^)(AEMyOrderList * item))success {
    WS(weakSelf);
    [self hudShow:self.view msg:@"生成订单.."];
    NSMutableArray * paramArray = @[].mutableCopy;
    for (AEExamItem * item in self.dataSources) {
        [paramArray addObject:@{@"goods_type":@"subject",@"goods_id":item.id,@"goods_num":@"1"}];
    }
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


- (void)loadData:(NSArray *)data {
    self.dataSources = data.mutableCopy;
    _totalPrice = 0.00;
    for (AEExamItem * item in self.dataSources) {
        _totalPrice += item.subject_price.floatValue;
    }
    self.footerView.priceLabel.text = [NSString stringWithFormat:@"%.2f",_totalPrice];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEOrderDetailCell * cell = [AEOrderDetailCell cellWithTableView:tableView];
    if (self.dataSources.count) {
        [cell updateCell:self.dataSources[indexPath.row]];
    }
    return cell;
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
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }else {
            [AEBase alertMessage:@"购买成功" cb:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(AEOrderDetailFooterView *)footerView {
    if (!_footerView) {
        WS(weakSelf)
        _footerView = [[NSBundle mainBundle]loadNibNamed:@"AEOrderDetailFooterView" owner:nil options:nil].firstObject;
        _footerView.buyNowBlock = ^{
            [weakSelf buyExam];
        };
    }
    return _footerView;
}


@end
