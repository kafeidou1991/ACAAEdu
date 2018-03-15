//
//  AEMyOrderVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/9.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyOrderVC.h"
#import "AEMyOrderCell.h"
#import "AEMyOrderHeaderView.h"

static const CGFloat headerViewHeight = 110.f;

@interface AEMyOrderVC ()

@end

@implementation AEMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    [self createTableViewStyle:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)afterProFun {
    WS(weakSelf);
    //  18516981076
    [self hudShow:self.view msg:STTR_ater_on];
    //    @{@"pay_status":@"1",@"lastid":@"0"}
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kOrderList query:nil path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        weakSelf.dataSources = [NSArray yy_modelArrayWithClass:[AEMyOrderList class] json:object].mutableCopy;
        NSLog(@"%@",weakSelf.dataSources);
        
        
        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}

#pragma mark - tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;//self.dataSources.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEMyOrderCell * cell = [AEMyOrderCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerViewHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[AEMyOrderHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerViewHeight)];
    
    return view;
}




@end
