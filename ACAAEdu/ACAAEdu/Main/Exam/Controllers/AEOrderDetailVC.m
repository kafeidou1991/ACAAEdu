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

@interface AEOrderDetailVC ()
@property (nonatomic, strong) AEOrderDetailFooterView * footerView;
@end

@implementation AEOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"订单详情";
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = self.footerView;
    
}
- (void)loadData:(NSArray *)data {
    self.dataSources = data.mutableCopy;
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEOrderDetailCell * cell = [AEOrderDetailCell cellWithTableView:tableView];
    
    return cell;
}

-(AEOrderDetailFooterView *)footerView {
    if (!_footerView) {
        WS(weakSelf)
        _footerView = [[NSBundle mainBundle]loadNibNamed:@"AEOrderDetailFooterView" owner:nil options:nil].firstObject;
        _footerView.buyNowBlock = ^{
            AEOrderPayVC * VC = [AEOrderPayVC new];
            [weakSelf.navigationController pushViewController:VC animated:YES];
        };
    }
    return _footerView;
}


@end
