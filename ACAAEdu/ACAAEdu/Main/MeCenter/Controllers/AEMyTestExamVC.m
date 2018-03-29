//
//  AEMyTestExamVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/26.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyTestExamVC.h"
#import "AEHomePageCell.h"
#import "AEExamItem.h"
#import "AEExamPaperInfoVC.h"


@interface AEMyTestExamVC ()

@end

@implementation AEMyTestExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    self.tableView.height -= 44;
}

- (void)initTableView {
    WS(weakSelf)
    [self createTableViewStyle:UITableViewStylePlain];
    [self addHeaderRefesh:NO Block:^{
        [weakSelf afterProFun];
    }];
    [self createEmptyViewBlock:^{
        [weakSelf afterProFun];
    }];
}

-(void)afterProFun {
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kMyTestExamList query:nil path:nil body:@{@"status":(_examType == NoneTestExamType ? @"1" : @"2")} success:^(id object) {
        weakSelf.dataSources = [NSArray yy_modelArrayWithClass:[AEExamItem class] json:object[@"data"]].mutableCopy;
        [weakSelf endLoadData];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf endLoadData];
        [AEBase alertMessage:error cb:nil];
    }];
}
- (void)endLoadData {
    [self hudclose];
    [self endRefesh:YES];
    [self.tableView reloadData];
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
    [cell updateMyTestExamCell:self.dataSources[indexPath.section] done:_examType];
    cell.buyBlock = ^{
        AEExamPaperInfoVC * VC = [AEExamPaperInfoVC new];
        VC.examItem = self.dataSources[indexPath.section];
        [weakSelf.navigationController pushViewController:VC animated:YES];
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
    
    
    
}





@end
