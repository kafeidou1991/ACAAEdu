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
#import "AEExamPaperVC_deprecated.h"
#import "AEExamPaperVC.h"
#import "AEExamAnalyzeVC.h"
#import "AEBindIdCardVC.h"



@interface AEMyTestExamVC ()

@end

@implementation AEMyTestExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self topNavtiation];
    self.baseTopView.titleName = @"我的模考";
    [self initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.frame = CGRectMake(0, ySpace, SCREEN_WIDTH, SCREEN_HEIGHT - AEBaseTopViewHeight - 44.f - HOME_INDICATOR_HEIGHT);
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
    NSDictionary * pramDict = @{@"page":[NSString stringWithFormat:@"%ld",self.currPage]};
//     pramDict = @{@"status":(_examType == NoneTestExamType ? @"1" : @"2"),@"page":[NSString stringWithFormat:@"%ld",self.currPage]};
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kMyTestExamList query:nil path:nil body:pramDict success:^(id object) {
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
    [cell updateMyTestExamCell:self.dataSources[indexPath.row]];
    return cell;
}
- (void) pushExamVC:(NSIndexPath * )indexPath {
    if (STRISEMPTY(User.id_card)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先绑定您的身份证信息" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                PUSHCustomViewController([AEBindIdCardVC new], self);
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        });
        return;
    }
    AEMyExamItem * item = self.dataSources[indexPath.row];
    if (item.status.intValue == 2) {
        //已经考试
        AEExamAnalyzeVC * VC = [AEExamAnalyzeVC new];
        AEMyExamItem * item = self.dataSources[indexPath.row];
        VC.examId = item.id;
        [self.navigationController pushViewController:VC animated:YES];
    }else {
        AEExamPaperVC * VC = [AEExamPaperVC new];
        VC.examItem = self.dataSources[indexPath.row];
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

//顶部导航
- (void)topNavtiation {
    [self.view addSubview:self.baseTopView];
    self.baseTopView.titleName = @"我的模考";
    self.baseTopView.imageViewName = @"exam_top_banner";
}


@end
