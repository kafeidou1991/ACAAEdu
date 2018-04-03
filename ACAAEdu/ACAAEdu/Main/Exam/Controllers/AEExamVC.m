//
//  AEExamVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/8.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamVC.h"
#import "AEHomePageCell.h"
#import "AEOrderDetailVC.h"
#import "AEExamItem.h"
#import "AEGoodsBasketView.h"
#import "AEScreeningVC.h"
typedef NS_ENUM(NSInteger, BuyExamType) {
    BuySigleExamType = 0,  //单选购买考试
    BuyMoreExamType        //多选购买考试
};
static CGFloat const GoodsViewHeight = 50.f;

@interface AEExamVC ()

@property (nonatomic, assign) BuyExamType buyType;
@property (nonatomic, strong) AEGoodsBasketView * goodsView; //购物篮
/**
 请求参数
 */
@property (nonatomic, strong) NSMutableDictionary * pararsDict;
@end

@implementation AEExamVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //重置选择项
    self.currPage = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;//[AEBase createCustomBarButtonItem:self action:@selector(moreList) title:@"更多"];
    self.navigationItem.rightBarButtonItem = [AEBase createCustomBarButtonItem:self action:@selector(matchItem) title:@"筛选"];
    [self initComponent];
}
#pragma mark - 更多
- (void)moreList {
    self.navigationItem.leftBarButtonItem = [AEBase createCustomBarButtonItem:self action:@selector(moreList) title:_buyType == BuyMoreExamType ? @"多选":@"取消"];
    self.navigationItem.rightBarButtonItem = [AEBase createCustomBarButtonItem:self action:@selector(matchItem) title:_buyType == BuyMoreExamType ? @"筛选":@""];
    _buyType = !_buyType;
    [self.tableView reloadData];
    [self showOrHiddenGoodsView:_buyType];
    [self.goodsView updateGoods:[self matchSelectItem]];
}
#pragma mark - 筛选
- (void)matchItem {
    WS(weakSelf);
    AEScreeningVC * screenVC = [AEScreeningVC new];
    screenVC.resultBlock = ^(NSDictionary * dict) {
        weakSelf.pararsDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [weakSelf.pararsDict setObject:@(weakSelf.currPage) forKey:@"page"];
        [weakSelf loadData:YES];
    };
    [self.navigationController pushViewController:screenVC animated:YES];
}
- (void)initComponent {
    self.buyType = BuySigleExamType;
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - TAB_BAR_HEIGHT);
    WS(weakSelf)
    [self createEmptyViewBlock:^{
        [weakSelf loadData:YES];
    }];
    [weakSelf addHeaderRefesh:NO Block:^{
        [weakSelf afterProFun];
    }];
}
-(void)afterProFun {
    self.pararsDict = @{@"page" : @(self.currPage)}.mutableCopy;
    [self loadData:YES];
}
- (void)loadData:(BOOL)isLoad {
    if (isLoad) {
        [self hudShow:self.view msg:STTR_ater_on];
    }
    WS(weakSelf);
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kIndexList query:nil path:nil body:self.pararsDict.copy success:^(id object) {
        isLoad ? [weakSelf hudclose] : nil;
        [weakSelf endRefesh:YES];
        [weakSelf endRefesh:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"data"]count] > 0) {
                if (weakSelf.currPage == 1) {
                    [weakSelf.dataSources removeAllObjects];
                }
                [weakSelf.dataSources addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AEExamItem class] json:object[@"data"]]];
                [weakSelf.tableView reloadData];
                NSInteger total = [object[@"total"] integerValue];
                if (total > 1) {
                    if (weakSelf.currPage < total) {
                        [weakSelf addFooterRefesh:^{
                            [weakSelf loadData:NO];
                        }];
                    }else{
                        [weakSelf noHasMoreData];
                    }
                }
            }else{
                //超过一页 服务器没返回数据
                if (weakSelf.currPage > 1) {
                    weakSelf.currPage = 1;
                    [weakSelf noHasMoreData];
                }
            }
        });
    } faile:^(NSInteger code, NSString *error) {
        isLoad ? [weakSelf hudclose] : nil;
        [weakSelf endRefesh:YES];
        [weakSelf endRefesh:NO];
        [AEBase alertMessage:error cb:nil];
    }];
}


#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSources.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEHomePageCell * cell = [AEHomePageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WS(weakSelf)
    if (_buyType == BuySigleExamType) {
        [cell updateCell:self.dataSources[indexPath.section]];
    }else {
        [cell updateMoreCell:self.dataSources[indexPath.section]];
    }
    //点击购买
    cell.buyBlock = ^{
        [weakSelf pushOrderDetailVC:@[weakSelf.dataSources[indexPath.section]]];
    };
    //多选
    cell.moreBlock = ^(UIButton * btn) {
        [weakSelf changeItemInfo:indexPath];
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
    if (self.buyType == BuySigleExamType) {
        [self pushOrderDetailVC:@[self.dataSources[indexPath.section]]];
    }else {
        [self changeItemInfo:indexPath];
    }
}
#pragma mark - 改变多选选中单位
- (void)changeItemInfo:(NSIndexPath *)indexPath {
    AEExamItem * item = self.dataSources[indexPath.section];
    item.isSelect = !item.isSelect;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.goodsView updateGoods:[self matchSelectItem]];
}
- (void)pushOrderDetailVC:(NSArray *)data {
    AEOrderDetailVC * VC = [AEOrderDetailVC new];
    [VC loadData:data];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - UI懒加载
-(AEGoodsBasketView *)goodsView {
    if (!_goodsView) {
        
        _goodsView = [[NSBundle mainBundle]loadNibNamed:@"AEGoodsBasketView" owner:nil options:nil].firstObject;
        _goodsView.frame = CGRectMake(0, self.view.height - GoodsViewHeight , SCREEN_WIDTH, GoodsViewHeight);
        [self.view addSubview:_goodsView];
        WS(weakSelf)
        _goodsView.buyNowBlock = ^(NSArray * array) {
            [weakSelf pushOrderDetailVC:array];
        };
    }
    return _goodsView;
}
- (void)showOrHiddenGoodsView:(BOOL)isShow {
    self.goodsView.hidden = !isShow;
    self.tableView.height =  isShow ? SCREEN_HEIGHT - NAVIGATION_HEIGHT - TAB_BAR_HEIGHT - GoodsViewHeight : SCREEN_HEIGHT - NAVIGATION_HEIGHT - TAB_BAR_HEIGHT;
}
//找出已选择的多项项目
- (NSArray *)matchSelectItem {
    NSMutableArray * temp = @[].mutableCopy;
    for (AEExamItem * item in self.dataSources) {
        if (item.isSelect) {
            [temp addObject:item];
        }
    }
    return temp.copy;
}

@end
