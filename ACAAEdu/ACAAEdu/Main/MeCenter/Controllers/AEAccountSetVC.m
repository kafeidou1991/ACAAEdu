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
#import "AEInfoFooterView.h"

@interface AEAccountSetVC ()

@end

@implementation AEAccountSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTopView];
    self.baseTopView.titleName = @"账户安全";
    
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
- (void)tipBindIdCard {
    if (STRISEMPTY(User.id_card)) {
        self.tableView.tableFooterView = [UIView new];
    }else {
        self.tableView.tableFooterView = [self createFootView];
    }
}
- (AEInfoFooterView *)createFootView {
    AEInfoFooterView * footView = [[NSBundle mainBundle]loadNibNamed:@"AEInfoFooterView" owner:nil options:nil].firstObject;
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60.f);
    return footView;
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
            //解绑需要绑定身份证
            if (STRISEMPTY(User.id_card)) {
                [AEBase alertMessage:@"请先绑定身份证" cb:nil];
                return;
            }
        }
        [self.navigationController pushViewController:pushVC animated:YES];
    }else if (indexPath.row == 1) {
        if (STRISEMPTY(User.email)) {
            pushVC.type = BindEmailType;
        }else {
            pushVC.type = UnBindEmailType;
            //解绑需要绑定身份证
            if (STRISEMPTY(User.id_card)) {
                [AEBase alertMessage:@"请先绑定身份证" cb:nil];
                return;
            }
        }
        [self.navigationController pushViewController:pushVC animated:YES];
    }else {
        //身份证验证  不支持解绑
        if (STRISEMPTY(User.id_card)) {
            [self.navigationController pushViewController:[AEBindIdCardVC new] animated:YES];
        }else {
            [self tipBindIdCard];
        }
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
