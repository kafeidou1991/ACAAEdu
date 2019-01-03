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
#import "AEScreeningVC.h"
#import "AESearchExamVC.h"


@interface AEExamVC ()

/**
 请求参数
 */
@property (nonatomic, strong) NSMutableDictionary * pararsDict;
@property (nonatomic, assign) AEExamType examType;
@end

@implementation AEExamVC
- (instancetype)initWithType:(AEExamType)examType {
    if (self = [super init]) {
        self.examType = examType;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = @[[AEBase createCustomBarButtonItem:self action:nil image:@"navtaion_topstyle"],[AEBase createCustomBarButtonItem:self action:nil title:@"考试"]];
    [self initComponent];
}
#pragma mark - 更多

- (void)searchExam {
    PUSHCustomViewController([AESearchExamVC new], self);
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
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT- TAB_BAR_HEIGHT);
    WS(weakSelf)
    [self createEmptyViewBlock:^{
        [weakSelf loadData:YES];
    }];
    [weakSelf addHeaderRefesh:NO Block:^{
        [weakSelf afterProFun];
    }];
}
-(void)afterProFun {
    [self loadData:YES];
}
- (void)loadData:(BOOL)isLoad {
    self.pararsDict = @{@"page" : @(self.currPage)}.mutableCopy;
    if (isLoad) {
        [self hudShow:self.view msg:STTR_ater_on];
    }
    WS(weakSelf);
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:_examType == AEExamACAAType ? kAcaaList : kAutodeskList query:self.pararsDict path:nil body:nil success:^(id object) {
        isLoad ? [weakSelf hudclose] : nil;
        [weakSelf endRefesh:YES];
        [weakSelf endRefesh:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.currPage == 1) {
                [weakSelf.dataSources removeAllObjects];
            }
            if ([object[@"data"]count] > 0) {
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
                [weakSelf.tableView reloadData];
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
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSources.count;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEHomePageCell * cell = [AEHomePageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WS(weakSelf)
    [cell updateCell:self.dataSources[indexPath.row]];
    //点击购买
    cell.buyBlock = ^{
        [weakSelf pushOrderDetailVC:weakSelf.dataSources[indexPath.row]];
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
    [self pushOrderDetailVC:self.dataSources[indexPath.row]];
}

- (void)pushOrderDetailVC:(AEExamItem *)item {
    AEOrderDetailVC * VC = [AEOrderDetailVC new];
    VC.item = item;
    PUSHLoginCustomViewController(VC, self);
}

@end
