//
//  MeCenterVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMeCenterVC.h"
#import "MeCenterCell.h"
#import "MeCenterHeaderView.h"
#import "AEAboutMeVC.h"
#import "AEMyOrderVC.h"
#import "AESettingVC.h"
#import "AECustomSegmentVC.h"
#import "AEMessageListVC.h"
#import "AEMyTestExamVC.h"
#import "AEAccountSetVC.h"
#import "AEModifierInfoVC.h"
#import "AEBindIdCardVC.h"
#import "AEUserInfoVC.h"

@interface AEMeCenterVC ()
@property (nonatomic, strong) MeCenterHeaderView * loginHeaderView;
@end

@implementation AEMeCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
//    self.view.backgroundColor = UIColorFromRGB(0x747476);
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"login_bg"].CGImage;
    [self addNotifications];
    self.dataSources =@[@{@"icon" :@"meceter1",@"title":@"设置",@"des":@""},
                        @{@"icon" :@"meceter2",@"title":@"通知",@"des":@""},
                        @{@"icon" :@"meceter3",@"title":@"我的模考",@"des":@""},
                        @{@"icon" :@"meceter4",@"title":@"我的订单",@"des":@""},
                        @{@"icon" :@"meceter5",@"title":@"关于我们",@"des":@""}].mutableCopy;
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self createHeaderView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateInfo];
    [self getNoPayOrderCount];
}

- (void)addNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo) name:kLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo) name:kLoginExit object:nil];
}

#pragma mark - 登陆成功
- (void)updateInfo {
    if (User.isLogin) {
        self.dataSources =@[@{@"icon" :@"meceter1",@"title":@"设置",@"des":@""},
                            @{@"icon" :@"meceter2",@"title":@"通知",@"des":@""},
                            @{@"icon" :@"meceter3",@"title":@"我的模考",@"des":@""},
                            @{@"icon" :@"meceter4",@"title":@"我的订单",@"des":@""},
                            @{@"icon" :@"meceter5",@"title":@"关于我们",@"des":@""},
                            @{@"icon" :@"meceter6",@"title":@"退出",@"des":@""}].mutableCopy;
    }else {
        self.dataSources =@[@{@"icon" :@"meceter1",@"title":@"设置",@"des":@""},
                            @{@"icon" :@"meceter2",@"title":@"通知",@"des":@""},
                            @{@"icon" :@"meceter3",@"title":@"我的模考",@"des":@""},
                            @{@"icon" :@"meceter4",@"title":@"我的订单",@"des":@""},
                            @{@"icon" :@"meceter5",@"title":@"关于我们",@"des":@""}].mutableCopy;
    }
    [self.loginHeaderView updateheaderInfo];
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeCenterCell * cell = [MeCenterCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dict = self.dataSources[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:dict[@"icon"]];
    cell.titleLabel.text = dict[@"title"];
    if (STRISEMPTY(dict[@"des"])) {
        cell.rightLabel.hidden = YES;
    }else {
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = dict[@"des"];
    }
    if ([dict[@"title"] isEqualToString:@"退出"]) {
        cell.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    }else {
        cell.backgroundColor = [UIColor clearColor];
    }
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
    });
}
- (void)headerClickToLogin {
    [self.loginHeaderView loginClick:nil];
}

#pragma mark - 跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * title = self.dataSources[indexPath.row][@"title"];
    if ([title isEqualToString:@"关于我们"]) {
        PUSHCustomViewController([AEAboutMeVC new], self)
    }else if ([title isEqualToString:@"我的订单"]) {
        AECustomSegmentVC * customVC = [AECustomSegmentVC new];
        customVC.baseTopView.titleName = @"我的订单";
        AEMyOrderVC * noPayVC = [[AEMyOrderVC alloc] init];
        noPayVC.payType = ExamNoPayType;
        AEMyOrderVC * hasPayVC = [[AEMyOrderVC alloc] init];
        hasPayVC.payType = ExamHasPayType;
        [customVC setupPageView:@[@"未支付",@"已支付"] ContentViewControllers:@[noPayVC, hasPayVC]];
        PUSHLoginCustomViewController(customVC, self)
    }else if ([title isEqualToString:@"设置"]) {
        PUSHCustomViewController([AESettingVC new], self)
    }else if ([title isEqualToString:@"通知"]) {
        AECustomSegmentVC * customVC = [AECustomSegmentVC new];
        customVC.baseTopView.titleName = @"通知";
        AEMessageListVC * unReadMessageVC = [[AEMessageListVC alloc] init];
        unReadMessageVC.messageType = UnReadMessageListType;
        AEMessageListVC *readMessageVC = [[AEMessageListVC alloc] init];
        readMessageVC.messageType = ReadMessageListType;
        [customVC setupPageView:@[@"未读", @"已读"] ContentViewControllers:@[unReadMessageVC, readMessageVC]];
        PUSHLoginCustomViewController(customVC, self)
    }else if ([title isEqualToString:@"我的模考"]) {
//        AECustomSegmentVC * customVC = [AECustomSegmentVC new];
//        customVC.baseTopView.titleName = @"我的模考";
//        AEMyTestExamVC * noExamVC = [[AEMyTestExamVC alloc] init];
//        noExamVC.examType = NoneTestExamType;
//        AEMyTestExamVC * hasExamVC = [[AEMyTestExamVC alloc] init];
//        hasExamVC.examType = HasTestExamType;
//        [customVC setupPageView:@[@"未考试",@"已考试"] ContentViewControllers:@[noExamVC,hasExamVC]];
        AEMyTestExamVC * noExamVC = [[AEMyTestExamVC alloc] init];
        PUSHLoginCustomViewController(noExamVC, self)
    }else if ([title isEqualToString:@"退出"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exitAction];
        });
    }
}
#pragma mark - 查询未支付订单个数
- (void)getNoPayOrderCount {
    WS(weakSelf)
    NSMutableDictionary * dict = @{@"pay_status":@"0"}.mutableCopy;
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kOrderList query:dict path:nil body:nil success:^(id object) {
        NSArray * tempArray = [NSArray yy_modelArrayWithClass:[AEMyOrderList class] json:object];
        //我的订单
        NSMutableDictionary * mutableDict = [weakSelf.dataSources[3] mutableCopy];
        if (tempArray.count > 0) {
            [mutableDict setObject:[NSString stringWithFormat:@"未完成订单  %lu",(unsigned long)tempArray.count] forKey:@"des"];
        }else {
            [mutableDict setObject:@"" forKey:@"des"];
        }
        [weakSelf.dataSources replaceObjectAtIndex:3 withObject:mutableDict.copy];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } faile:^(NSInteger code, NSString *error) {
        [AEBase alertMessage:error cb:nil];
    }];
}


#pragma mark - 退出登录
- (void)exitAction{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要退出么？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exit];
        });
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)exit {
    [[AEUserInfo shareInstance]removeLoginData];
    [[NSNotificationCenter defaultCenter]postNotificationName:kLoginExit object:nil];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kLogout query:nil path:nil body:nil success:^(id object) {
    } faile:^(NSInteger code, NSString *error) {
        [AEBase alertMessage:error cb:nil];
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
