//
//  AEMyOrderVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/9.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyOrderVC.h"
#import "AEMyOrderCell.h"
#import "AEMyOrderFooterView.h"
#import "AEOrderPayVC.h"
#import "AEOrderDetailVC.h"

static const CGFloat headerViewHeight = 145.f;

@interface AEMyOrderVC ()

@property (nonatomic, copy) NSString * lastId;

@end

@implementation AEMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - AEBaseTopViewHeight - 44.f - HOME_INDICATOR_HEIGHT);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refrshLoad) name:kPayOrderSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refrshLoad) name:kOrderDeleteSuccess object:nil];
}

//初始化tableview
- (void)initTableView {
    [self createTableViewStyle:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WS(weakSelf)
    [self createEmptyViewBlock:^{
        [weakSelf afterProFun];
    }];
    [self addHeaderRefesh:NO Block:^{
        [weakSelf refrshLoad];
    }];
    [self addFooterRefesh:^{
        [weakSelf afterProFun];
    }];
}
//下拉刷新
- (void)refrshLoad {
    _lastId = @"";
    [self.dataSources removeAllObjects];
    [self afterProFun];
}

-(void)afterProFun {
    WS(weakSelf);
    //  18516981076
//    13146482283   5585320
    [self hudShow:self.view msg:STTR_ater_on];
    //    @{@"pay_status":@"1",@"lastid":@"0"} @{@"lastid":@"9"}
    NSMutableDictionary * dict = @{@"pay_status":(_payType == ExamNoPayType ? @"0" : @"1")}.mutableCopy;
    if (!STRISEMPTY(_lastId)) {
        [dict setObject:_lastId forKey:@"lastid"];
    }
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kOrderList query:dict path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        [weakSelf endRefesh:YES];
        [weakSelf endRefesh:NO];
        NSArray * tempArray = [NSArray yy_modelArrayWithClass:[AEMyOrderList class] json:object];
        if (tempArray.count > 0) {
            AEMyOrderList * lastItem = [tempArray lastObject];
            weakSelf.lastId = lastItem.id;
            [weakSelf.dataSources addObjectsFromArray:tempArray];
             [weakSelf.tableView reloadData];
        }else {
            [weakSelf noHasMoreData];
        }

        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [weakSelf endRefesh:YES];
        [weakSelf endRefesh:NO];
        [AEBase alertMessage:error cb:nil];
    }];
}

#pragma mark - tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSources.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AEMyOrderList * good = self.dataSources[section];
    return good.goods.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEMyOrderCell * cell = [AEMyOrderCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AEMyOrderList * good = self.dataSources[indexPath.section];
    [cell updateCell:good.goods[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return headerViewHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    AEMyOrderFooterView * view = [[AEMyOrderFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerViewHeight)];
    AEMyOrderList * good = self.dataSources[section];
    [view updateContent:good];
    WS(weakSelf)
    view.clickBlock = ^{
        [weakSelf gotoNextStep:good];
    };
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8.f)];
    return view;
}
//点击跳转
- (void)gotoNextStep:(AEMyOrderList *)item {
    AEOrderDetailVC * VC = [AEOrderDetailVC new];
    VC.comeType =ComeFromMyOrderType;
    VC.orderList = item;
    if (_payType == ExamNoPayType) {
        VC.payStatus = AEOrderPayingStatus;
    }else {
        VC.payStatus = AEOrderPaidStatus;
    }
    PUSHCustomViewController(VC, self);
    
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
