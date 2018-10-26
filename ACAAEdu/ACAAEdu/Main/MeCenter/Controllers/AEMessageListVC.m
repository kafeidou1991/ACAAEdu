//
//  AEMessageListVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/16.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMessageListVC.h"
#import "AEMessageListCell.h"

@interface AEMessageListVC ()

@end

@implementation AEMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - AEBaseTopViewHeight - 44.f - HOME_INDICATOR_HEIGHT);
    
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
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kMessageList query:@{@"status":(_messageType == UnReadMessageListType ? @"0" : @"1"),@"page":[NSString stringWithFormat:@"%ld",self.currPage]}.mutableCopy path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        [weakSelf endRefesh:YES];
        [weakSelf endRefesh:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"data"]count] > 0) {
                if (weakSelf.currPage == 1) {
                    [weakSelf.dataSources removeAllObjects];
                }
                [weakSelf.dataSources addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AEMessageList class] json:object[@"data"]]];
                [weakSelf.tableView reloadData];
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
        });
        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
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


@end
