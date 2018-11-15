//
//  AEMyTestExamVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/26.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyTestExamVC.h"
//#import "AEHomePageCell.h"
#import "AEMyExamCell.h"
#import "AEExamItem.h"
#import "AEExamPaperVC_deprecated.h"
#import "AEExamResultVC.h"
#import "AEExamPaperVC.h"



@interface AEMyTestExamVC ()

@end

@implementation AEMyTestExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - AEBaseTopViewHeight - 44.f - HOME_INDICATOR_HEIGHT);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afterProFun) name:@"kExamResultBack" object:nil];
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
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kMyTestExamList query:nil path:nil body:@{@"status":(_examType == NoneTestExamType ? @"1" : @"2"),@"page":[NSString stringWithFormat:@"%ld",self.currPage]} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.currPage == 1) {
                [weakSelf.dataSources removeAllObjects];
            }
            if ([object[@"data"]count] > 0) {
                [weakSelf.dataSources addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AEMyExamItem class] json:object[@"data"]]];
                [weakSelf endLoadData];
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
                [weakSelf endLoadData];
                //超过一页 服务器没返回数据
                if (weakSelf.currPage > 1) {
                    weakSelf.currPage = 1;
                    [weakSelf noHasMoreData];
                }
            }
        });
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf endLoadData];
        [AEBase alertMessage:error cb:nil];
    }];
}
- (void)endLoadData {
    [self hudclose];
    [self endRefesh:YES];
    [self endRefesh:NO];
    [self.tableView reloadData];
}


#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEMyExamCell * cell = [AEMyExamCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateMyTestExamCell:self.dataSources[indexPath.row] done:_examType];
    return cell;
}
- (void) pushExamVC:(NSIndexPath * )indexPath {
    if (_examType == NoneTestExamType) {
//        AEExamPaperInfoVC * VC = [AEExamPaperInfoVC new];
        AEExamPaperVC * VC = [AEExamPaperVC new];
        VC.examItem = self.dataSources[indexPath.row];
        [self.navigationController pushViewController:VC animated:YES];
    }else {
        AEExamResultVC * VC = [AEExamResultVC new];
        AEMyExamItem * item = self.dataSources[indexPath.row];
        VC.examId = item.id;
        [self.navigationController pushViewController:VC animated:YES];
    }
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
    [self pushExamVC:indexPath];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}




@end
