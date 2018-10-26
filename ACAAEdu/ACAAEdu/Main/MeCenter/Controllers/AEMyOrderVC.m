//
//  AEMyOrderVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/9.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyOrderVC.h"
#import "AEMyOrderCell.h"
#import "AEMyOrderHeaderView.h"
#import "AEOrderPayVC.h"

static const CGFloat headerViewHeight = 110.f;

@interface AEMyOrderVC ()

@property (nonatomic, copy) NSString * lastId;

@end

@implementation AEMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - AEBaseTopViewHeight - 44.f - HOME_INDICATOR_HEIGHT);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refrshLoad) name:kPayOrderSuccess object:nil];
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
        [weakSelf.dataSources addObjectsFromArray:tempArray];
        if (tempArray > 0) {
            AEMyOrderList * lastItem = [weakSelf.dataSources lastObject];
            weakSelf.lastId = lastItem.id;
        }else {
            [weakSelf noHasMoreData];
        }
        [weakSelf.tableView reloadData];

        
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
    [cell updateCell:good.goods[indexPath.row] hiddenTitle:indexPath.row != 0];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerViewHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AEMyOrderHeaderView * view = [[AEMyOrderHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerViewHeight)];
    AEMyOrderList * good = self.dataSources[section];
    [view updateContent:good];
    WS(weakSelf)
    view.clickBlock = ^{
        [weakSelf gotoNextStep:good];
    };
    return view;
}
//点击跳转
- (void)gotoNextStep:(AEMyOrderList *)item {
    //未支付 跳转支付
    if ([item.pay_status isEqualToString:@"0"]) {
        AEOrderPayVC * VC = [AEOrderPayVC new];
        VC.item = item;
        VC.totalPrice = item.pay_price.floatValue;
        VC.comeType =ComeFromMyOrderType;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
