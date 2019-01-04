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
#import "AEExamItem.h"
#import "AEHomeNoticeIconView.h"
#import "AEMessageListVC.h"
#import "AECustomSegmentVC.h"

#import "AEExamInfoVC.h"

@interface AEHomePageVC ()
@property (nonatomic, strong) HomeHeaderReusableView * headerView;
@property (nonatomic, strong) AEHomeNoticeIconView * noticeView;

@end

@implementation AEHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = @[[AEBase createCustomBarButtonItem:self action:nil image:@"navtaion_topstyle"],[AEBase createCustomBarButtonItem:self action:nil title:@"首页"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.noticeView];
    [self.noticeView addTarget:self action:@selector(gotoNoticeDetail) forControlEvents:UIControlEventTouchUpInside];
    
    [self initTableView];
    
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:btn];
//    btn.frame = CGRectMake(100, 100, 100, 100);
//    [btn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    [self.noticeView updateNoShowNumber:0];
}
- (void)buy {
    [self.navigationController pushViewController:[AEExamInfoVC new] animated:YES];
}

- (void)initTableView {
    WS(weakSelf)
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, ySpace, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - TAB_BAR_HEIGHT  - ySpace);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = AEColorLine;
    self.tableView.tableHeaderView = self.headerView;
    [self addHeaderRefesh:NO Block:^{
        [weakSelf afterProFun];
    }];
}

-(void)afterProFun {
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    __block NSInteger isEnd = - 2; //控制请求是否完成
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kRecommendSubjectList query:nil path:nil body:nil success:^(id object) {
        isEnd += 1;
        weakSelf.dataSources = [NSArray yy_modelArrayWithClass:[AEExamItem class] json:object].mutableCopy;
        [weakSelf endLoadData:isEnd];
    } faile:^(NSInteger code, NSString *error) {
        isEnd += 1;
        [weakSelf endLoadData:isEnd];
        [AEBase alertMessage:error cb:nil];
    }];
    
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kBanner query:nil path:nil body:nil success:^(id object) {
        isEnd += 1;
        if ([object isKindOfClass:[NSArray class]]) {
            //轮播图
            [weakSelf.headerView updateBanner:object];
        }
        [weakSelf endLoadData:isEnd];
    } faile:^(NSInteger code, NSString *error) {
        isEnd += 1;
        [weakSelf endLoadData:isEnd];
        [AEBase alertMessage:error cb:nil];
    }];
}
- (void)endLoadData:(NSInteger)isEnd {
    if (isEnd >= 0) {
        [self hudclose];
        [self endRefesh:YES];
        [self.tableView reloadData];
    }
}


#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEHomePageCell * cell = [AEHomePageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WS(weakSelf)
    [cell updateCell:self.dataSources[indexPath.row]];
    cell.buyBlock = ^{
        [weakSelf pushOrderDetailVC:weakSelf.dataSources[indexPath.row]];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(separatorInset)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushOrderDetailVC:self.dataSources[indexPath.row]];
}
//MARK: 订单详情
- (void)pushOrderDetailVC:(AEExamItem *)item {
    AEOrderDetailVC * VC = [AEOrderDetailVC new];
    VC.item = item;
    PUSHLoginCustomViewController(VC, self);
}
//MARK: 通知列表
- (void)gotoNoticeDetail {
    AECustomSegmentVC * customVC = [AECustomSegmentVC new];
    customVC.baseTopView.titleName = @"通知";
    AEMessageListVC * unReadMessageVC = [[AEMessageListVC alloc] init];
    unReadMessageVC.messageType = UnReadMessageListType;
    AEMessageListVC *readMessageVC = [[AEMessageListVC alloc] init];
    readMessageVC.messageType = ReadMessageListType;
    [customVC setupPageView:@[@"未读", @"已读"] ContentViewControllers:@[unReadMessageVC, readMessageVC]];
    PUSHLoginCustomViewController(customVC, self)
}
#pragma mark - 懒加载
-(HomeHeaderReusableView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"HomeHeaderReusableView" owner:nil options:nil].firstObject;
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 185.f);
    }
    return _headerView;
}

-(AEHomeNoticeIconView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[AEHomeNoticeIconView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    return _noticeView;
}


@end
