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
#import "AEBindIdCardVC.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:kBindAccountSuccess object:nil];
}
- (void)reload {
    self.dataSources = @[@{@"title":@"手机号",@"value":User.mobile},
                         @{@"title":@"邮箱账号",@"value":User.email},
                         @{@"title":@"身份证账号",@"value":User.id_card}].mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - tableview delegate & datesource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEModifierInfoCell * cell = [AEModifierInfoCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dict = self.dataSources[indexPath.row];
    [cell updateCell:dict];
    WS(weakSelf);
    cell.actionBlock = ^{
        [weakSelf bindOrUnBindAction:indexPath];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self bindOrUnBindAction:indexPath];
}
- (void)bindOrUnBindAction:(NSIndexPath *)indexPath {
    AEModifierInfoVC * pushVC = [AEModifierInfoVC new];
    if (indexPath.row == 0) {
        if (STRISEMPTY(User.mobile)) {
            pushVC.type = BindMobileType;
        }else {
            pushVC.type = UnBindMobileType;
        }
        [self.navigationController pushViewController:pushVC animated:YES];
    }else if (indexPath.row == 1) {
        if (STRISEMPTY(User.email)) {
            pushVC.type = BindEmailType;
        }else {
            pushVC.type = UnBindEmailType;
        }
        [self.navigationController pushViewController:pushVC animated:YES];
    }else {
        //身份证验证  不支持解绑
        if (STRISEMPTY(User.id_card)) {
//            [self.navigationController pushViewController:[AERegistIdCardVC new] animated:YES];
            [self.navigationController pushViewController:[AEBindIdCardVC new] animated:YES];
        }
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
