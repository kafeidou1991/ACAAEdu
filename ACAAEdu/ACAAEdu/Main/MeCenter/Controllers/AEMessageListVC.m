//
//  AEMessageListVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/16.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMessageListVC.h"
#import "AEMessageListCell.h"
#import "AEMessageDetailVC.h"

@interface AEMessageListVC ()

@end

@implementation AEMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTopView];
    self.baseTopView.titleName = @"通知";
    [self initTableView];
    self.tableView.frame = CGRectMake(0, ySpace, SCREEN_WIDTH, SCREEN_HEIGHT - AEBaseTopViewHeight);
    
}
- (void)initTableView {
    [self createTableViewStyle:UITableViewStylePlain];
    WS(weakSelf)
    [self createEmptyViewBlock:^{
        [weakSelf afterProFun];
    }];
    [weakSelf addHeaderRefesh:NO Block:^{
        [weakSelf afterProFun];
    }];
}

-(void)afterProFun {
    [self loadData:YES];
}
- (void)loadData:(BOOL)isHud {
    WS(weakSelf);
    if (isHud) {
        [self hudShow:self.view msg:STTR_ater_on];
    }
//    @"status":(_messageType == UnReadMessageListType ? @"0" : @"1"),
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kMessageList query:@{@"page":[NSString stringWithFormat:@"%ld",self.currPage]}.mutableCopy path:nil body:nil success:^(id object) {
        if (isHud) {
            [weakSelf hudclose];
        }
        [weakSelf endRefesh:YES];
        [weakSelf endRefesh:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.currPage == 1) {
                [weakSelf.dataSources removeAllObjects];
            }
            if ([object[@"data"]count] > 0) {
                [weakSelf.dataSources addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AEMessageList class] json:object[@"data"]]];
                NSInteger total = [object[@"total"] integerValue];
                if (total > 1) {
                    if (weakSelf.currPage < total) {
                        [weakSelf addFooterRefesh:^{
                            [weakSelf afterProFun];
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
            [weakSelf.tableView reloadData];
        });
    } faile:^(NSInteger code, NSString *error) {
        if (isHud) {
            [weakSelf hudclose];
        }
        [weakSelf endRefesh:YES];
        [weakSelf endRefesh:NO];
        [AEBase alertMessage:error cb:nil];
    }];
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEMessageListCell * cell = [AEMessageListCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCell:self.dataSources[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AEMessageDetailVC * vc = [AEMessageDetailVC new];
    AEMessageList * item = self.dataSources[indexPath.row];
    vc.item = item;
    PUSHCustomViewController(vc, self);
    if ([item.status isEqualToString:@"0"]) {
        //标记未已读
        [self messageHasRead:item];
    }
}

- (void)messageHasRead:(AEMessageList *)item {
    WS(weakSelf)
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kMessageRead query:@{@"id":item.id}.mutableCopy path:nil body:nil success:^(id object) {
        [weakSelf loadData:NO];
    } faile:^(NSInteger code, NSString *error) {
        [AEBase alertMessage:error cb:nil];
    }];
}

@end
