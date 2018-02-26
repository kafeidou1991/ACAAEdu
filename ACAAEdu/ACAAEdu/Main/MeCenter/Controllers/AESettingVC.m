//
//  AESettingVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/12.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AESettingVC.h"
#import "AEAccountSetVC.h"

@interface AESettingVC ()

@end

@implementation AESettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.dataSources = @[@"账户安全",@"清除信息",@"版本信息"].mutableCopy;
    [self createTableViewStyle:UITableViewStylePlain];
    
    if ([AEUserInfo shareInstance].isLogin) {
        self.tableView.tableFooterView = [self _createFootView];
    }else{
        self.tableView.tableFooterView = [UIView new];
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    cell.textLabel.text = self.dataSources[indexPath.row];
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"";
    }else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fMB",[self computeCache]];
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",AEVersion];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[AEAccountSetVC new] animated:YES];
    }else if (indexPath.row == 1){
        [self cleanCache];
    }
}
#pragma mark - 退出登录
- (UIView *) _createFootView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = AEThemeColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.showsTouchWhenHighlighted = NO;
    btn.layer.cornerRadius = 5.f;
    [btn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(32, 60, SCREEN_WIDTH - 2 * 32, 40);
    [view addSubview:btn];
    return view;
}
- (void)exitAction{
//    NSDictionary * dict = @{@"token":[AEUserInfo shareInstance].isLogin};
    WS(weakSelf);
//    [self hudShow:self.view msg:STTR_ater_on];
//    [A PostWithUrl:Logout params:dict isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
//        [weakSelf hudclose];
//    } failed:^(NSError *error, id chaceResponseObject) {
//        [weakSelf hudclose];
//        [JJWBase alertMessage:error.domain cb:nil];
//    }];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要退出么？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[AEUserInfo shareInstance]removeLoginData];
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoginExit object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - 清楚缓存 计算缓存
- (float)computeCache{
    float cacheNum = 0.0;
    cacheNum += [[SDImageCache sharedImageCache] getSize]/1024.0f/1024.0f;
    return cacheNum;
}
- (void)cleanCache {
    [self hudShow:self.view msg:@"清除中..."];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self performSelector:@selector(close) withObject:nil afterDelay:1];
}
- (void)close
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hudclose];
        [AEBase alertMessage:@"缓存清除完成" cb:nil];
        [self.tableView reloadData];
    });
}

@end
