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
    self.dataSources = @[@{@"title":@"英文名",@"value":@""},
                         @{@"title":@"生日",@"value":@""},
                         @{@"title":@"所在地",@"value":@""},
                         @{@"title":@"详细地址",@"value":@""},
                         @{@"title":@"邮政编码",@"value":@""},
                         @{@"title":@"电话号码",@"value":@""},
                         @{@"title":@"传真号码",@"value":@""},
                         @{@"title":@"职业",@"value":@""},
                         @{@"title":@"学历",@"value":@""},
                         @{@"title":@"简介",@"value":@""}].mutableCopy;
    [self createTableViewStyle:UITableViewStylePlain];
}

#pragma mark - tableview delegate & datesource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEUserInfoCell * cell = [AEUserInfoCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSDictionary * dict = self.dataSources[indexPath.row];
    [cell updateCell:dict];
    [self textFieldPlacehold:indexPath Cell:cell];
    return cell;
}
- (void)textFieldPlacehold:(NSIndexPath *)indexPath Cell:(AEUserInfoCell *)cell {
    if (indexPath.row == 0 || indexPath.row == 3 ||indexPath.row == 4 ||indexPath.row == 5 ||indexPath.row == 6 ||indexPath.row == 9 ) {
        cell.contentTextField.placeholder = @"请输入";
        cell.contentTextField.enabled =YES;
    }else {
        cell.contentTextField.placeholder = @"请选择";
        cell.contentTextField.enabled = NO;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self birthday];
    }
    
    
//    AEUserInfoCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.contentTextField canBecomeFirstResponder]) {
//        [cell.contentTextField becomeFirstResponder];
//    }
}

#pragma mark - 处理事件
- (void)birthday {
    
}

@end
