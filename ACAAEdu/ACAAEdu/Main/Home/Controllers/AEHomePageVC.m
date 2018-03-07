//
//  HomePageVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEHomePageVC.h"
#import "AEHomePageCell.h"
#import "HomeHeaderReusableView.h"
#import "AEOrderDetailVC.h"

@interface AEHomePageVC ()
@property (nonatomic, strong) HomeHeaderReusableView * headerView;
@end

@implementation AEHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString * url =@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517936621904&di=59ff6ebac7e3d599f62849da4ba7a168&imgtype=jpg&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170626%2Fe27d47199ce645999100af5c0fc56f56_th.jpg";
        NSString * url1 =@"https://www.baidu.com/img/bd_logo1.png";
        NSString * url2 =@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517936621904&di=59ff6ebac7e3d599f62849da4ba7a168&imgtype=jpg&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170626%2Fe27d47199ce645999100af5c0fc56f56_th.jpg";
        NSArray * array = @[url,url1,url2];
        [self.headerView updateBanner:array];
    });
}

-(void)afterProFun {
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - TAB_BAR_HEIGHT);
    self.tableView.tableHeaderView = self.headerView;
}


#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEHomePageCell * cell = [AEHomePageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WS(weakSelf)
    cell.buyBlock = ^{
        [weakSelf.navigationController pushViewController:[AEOrderDetailVC new] animated:YES];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.f;
    }else {
        return 10.f;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[AEOrderDetailVC new] animated:YES];
}

#pragma mark - 懒加载
-(HomeHeaderReusableView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"HomeHeaderReusableView" owner:nil options:nil].firstObject;
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    }
    return _headerView;
}

@end
