//
//  MeCenterVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMeCenterVC.h"
#import "MeCenterCell.h"
#import "CExpandHeader.h"
#import "MeCenterHeaderView.h"
#import "AEAboutMeVC.h"
#import "AEMyOrderVC.h"
#import "AESettingVC.h"

static CGFloat customViewHeight = 180.f;

@interface AEMeCenterVC ()<UINavigationControllerDelegate>{
    CExpandHeader     *_header;             //可拉伸区域
}
@property (nonatomic, strong) MeCenterHeaderView * loginHeaderView;
@end

@implementation AEMeCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.navigationItem.leftBarButtonItem = nil;
    [self addNotifications];
    self.dataSources =@[@{@"icon" :@"meceter1",@"title":@"设置"},
                        @{@"icon" :@"meceter2",@"title":@"通知"},
                        @{@"icon" :@"meceter3",@"title":@"我的模考"},
                        @{@"icon" :@"meceter4",@"title":@"我的订单"},
                        @{@"icon" :@"meceter5",@"title":@"关于我们"}].mutableCopy;
    [self createTableViewStyle:UITableViewStylePlain];
    [self createHeaderView];
}
- (void)addNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo) name:kLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo) name:kLoginExit object:nil];
}

#pragma mark - 登陆成功
- (void)updateInfo {
    [self.loginHeaderView updateheaderInfo];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeCenterCell * cell = [MeCenterCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dict = self.dataSources[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:dict[@"icon"]];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
#pragma mark - 头部视图
- (void)createHeaderView {
    dispatch_async(dispatch_get_main_queue(), ^{
        //登录头像姓名
        _loginHeaderView = [[NSBundle mainBundle]loadNibNamed:@"MeCenterHeaderView" owner:nil options:nil].firstObject;
        [_loginHeaderView updateheaderInfo];
        self.tableView.tableHeaderView = _loginHeaderView;
        //背景
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, customViewHeight)];
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, customViewHeight)];
        bgView.userInteractionEnabled = YES;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        bgView.clipsToBounds = YES;
        bgView.image = [UIImage imageNamed:@"meCenterBg"];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        [customView addSubview:bgView];
        
        UIControl * control = [[UIControl alloc]initWithFrame:CGRectMake(0, bgView.height - 60, SCREEN_WIDTH, 60)];
        [control addTarget:self action:@selector(headerClickToLogin) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:control];
        
        _header = [CExpandHeader expandWithScrollView:self.tableView expandView:customView];
    });
}
- (void)headerClickToLogin {
    [self.loginHeaderView loginClick:nil];
}

#pragma mark - 跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * title = self.dataSources[indexPath.row][@"title"];
    if ([title isEqualToString:@"关于我们"]) {
        [self.navigationController pushViewController:[AEAboutMeVC new] animated:YES];
    }else if ([title isEqualToString:@"我的订单"]) {
        dispatch_block_t t = ^{
            [self.navigationController pushViewController:[AEMyOrderVC new] animated:YES];
        };
        if (User.isLogin) {
            t();
        }else {
            [AELoginVC OpenLogin:self callback:^(BOOL compliont) {
                t();
            }];
        }
    }else if ([title isEqualToString:@"设置"]) {
        [self.navigationController pushViewController:[AESettingVC new] animated:YES];
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//隐藏导航栏
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL home = [viewController isKindOfClass:[self class]];
    [navigationController setNavigationBarHidden:home animated:YES];
}
@end
