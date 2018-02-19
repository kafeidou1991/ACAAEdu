//
//  AEUserInfoVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/19.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEUserInfoVC.h"
#import "AEUserInfoCell.h"

@interface AEUserInfoVC ()

@end

@implementation AEUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.dataSources = @[@{@"title":@"手机号",@"value":User.mobile,@"status":@"1"},
                         @{@"title":@"邮箱账号",@"value":User.email,@"status":@"1"},
                         @{@"title":@"身份证账号",@"value":User.id_card,@"status":@"0"}].mutableCopy;
    [self createTableViewStyle:UITableViewStylePlain];
}

#pragma mark - tableview delegate & datesource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEUserInfoCell * cell = [AEUserInfoCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dict = self.dataSources[indexPath.row];
    [cell updateCell:dict];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}


@end
