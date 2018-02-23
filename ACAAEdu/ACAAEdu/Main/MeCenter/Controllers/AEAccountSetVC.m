//
//  AEAccountSetVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/23.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEAccountSetVC.h"
#import "AEModifierInfoCell.h"
#import "AEModifierInfoVC.h"

@interface AEAccountSetVC ()

@end

@implementation AEAccountSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户安全";
    self.dataSources = @[@{@"title":@"手机号",@"value":User.mobile},
                         @{@"title":@"邮箱账号",@"value":User.email},
                         @{@"title":@"身份证账号",@"value":User.id_card}].mutableCopy;
    [self createTableViewStyle:UITableViewStylePlain];
}

#pragma mark - tableview delegate & datesource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEModifierInfoCell * cell = [AEModifierInfoCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dict = self.dataSources[indexPath.row];
    [cell updateCell:dict];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[AEModifierInfoVC new] animated:YES];
}


@end
