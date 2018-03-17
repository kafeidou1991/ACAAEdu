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
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kMessageList query:nil path:nil body:@{@"status":(_messageType == UnReadMessageListType ? @"0" : @"1"),@"page":[NSString stringWithFormat:@"%ld",self.currPage]} success:^(id object) {
        [weakSelf hudclose];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEMessageListCell * cell = [AEMessageListCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}


@end
