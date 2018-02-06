//
//  MeCenterVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "MeCenterVC.h"
#import "MeCenterCell.h"

@interface MeCenterVC ()

@end

@implementation MeCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSources =@[@{@"icon" :@"meceter1",@"title":@"设置"},
                        @{@"icon" :@"meceter2",@"title":@"通知"},
                        @{@"icon" :@"meceter3",@"title":@"我的模考"},
                        @{@"icon" :@"meceter4",@"title":@"我的订单"},
                        @{@"icon" :@"meceter5",@"title":@"关于我们"}].mutableCopy;
    [self createTableViewStyle:UITableViewStylePlain];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeCenterCell * cell = [MeCenterCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dict = self.dataSources[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:dict[@"icon"]];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}




@end
