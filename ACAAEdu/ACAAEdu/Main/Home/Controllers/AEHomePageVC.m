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

//Temp
#import "AEPurchaseManage.h"
#import "AEExamResultVC.h"

@interface AEHomePageVC ()
@property (nonatomic, strong) HomeHeaderReusableView * headerView;

//@property (nonatomic, strong) AEPurchaseManage * mange;
@end

@implementation AEHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = nil;
    [self initTableView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSString * url =@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517936621904&di=59ff6ebac7e3d599f62849da4ba7a168&imgtype=jpg&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170626%2Fe27d47199ce645999100af5c0fc56f56_th.jpg";
//        NSString * url1 =@"https://www.baidu.com/img/bd_logo1.png";
//        NSString * url2 =@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517936621904&di=59ff6ebac7e3d599f62849da4ba7a168&imgtype=jpg&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170626%2Fe27d47199ce645999100af5c0fc56f56_th.jpg";
//        NSArray * array = @[url,url1,url2];
//        [self.headerView updateBanner:array];
//    });
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:btn];
//    btn.frame = CGRectMake(100, 100, 100, 100);
//    [btn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buy {
//    _mange = [AEPurchaseManage new];
//    [_mange startPurchWithID:@"com.acaaedu.1" completeHandle:^(IAPPurchType type, NSData *data) {
//        NSLog(@"回调");
//
//    }];
    [self.navigationController pushViewController:[AEExamResultVC new] animated:YES];
}

- (void)initTableView {
    WS(weakSelf)
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - TAB_BAR_HEIGHT);
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
        [weakSelf pushOrderDetailVC:@[self.dataSources[indexPath.row]]];
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
    [self pushOrderDetailVC:@[self.dataSources[indexPath.row]]];
}

- (void)pushOrderDetailVC:(NSArray *)data {
    AEOrderDetailVC * VC = [AEOrderDetailVC new];
    [VC loadData:data];
    PUSHLoginCustomViewController(VC, self);
}

#pragma mark - 懒加载
-(HomeHeaderReusableView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"HomeHeaderReusableView" owner:nil options:nil].firstObject;
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 185.f);
    }
    return _headerView;
}

@end
