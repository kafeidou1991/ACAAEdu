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

@interface AEExamVC ()

@end

@implementation AEExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [AEBase createCustomBarButtonItem:self action:@selector(moreList) title:@"更多"];
    
}
- (void)moreList {
    
}
- (void)initComponent {
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - TAB_BAR_HEIGHT);
    WS(weakSelf)
    [self createEmptyViewBlock:^{
        [weakSelf loadData:YES];
    }];
}
-(void)afterProFun {
    [self loadData:YES];
}
- (void)loadData:(BOOL)isLoad {
    if (isLoad) {
        [self hudShow:self.view msg:STTR_ater_on];
    }
    WS(weakSelf);
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kSubjectList query:nil path:nil body:@{@"page" : @(self.currPage)} success:^(id object) {
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
                [weakSelf addHeaderRefesh:NO Block:^{
                    [weakSelf afterProFun];
                }];
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
//                [self createEmptyView];
//                [_emptyView setRefreshButtonHiden:YES];
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
    cell.buyBlock = ^{
        [weakSelf.navigationController pushViewController:[AEOrderDetailVC new] animated:YES];
    };
    [cell updateCell:self.dataSources[indexPath.section]];
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
    [self.navigationController pushViewController:[AEOrderDetailVC new] animated:YES];
}


#pragma mark - UI懒加载


@end
