//
//  HomePageVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEHomePageVC.h"
#import "AEHomePageCell.h"
#import "AEHomeHeaderView.h"
#import "AEOrderDetailVC.h"
#import "AEHomeNoticeIconView.h"
#import "AEMessageListVC.h"
#import "AECustomSegmentVC.h"
#import "AEExamInfoVC.h"
#import "AEHomeSectionView.h"
#import "AEHomeModuleItem.h"

@interface AEHomePageVC ()
@property (nonatomic, strong) AEHomeHeaderView * headerView;
@property (nonatomic, strong) AEHomeNoticeIconView * noticeView;

@end

@implementation AEHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = nil;
    [self initTableView];
    [self.noticeView updateNoShowNumber:0];
}
- (void)buy {
    [self.navigationController pushViewController:[AEExamInfoVC new] animated:YES];
}

- (void)initTableView {
    for (int i = 0; i < 2; i++) {
        AEHomeModuleItem * item = [AEHomeModuleItem new];
        if (i == 0) {
//            是否展开
            item.sectionItem = [AEHomeSectionItem yy_modelWithDictionary:@{@"image":@"home_my_exam",@"title":@"我的考试",@"isExpand":@1,@"backgroundColor":@"4FD2C2"}];
        }else {
            item.sectionItem = [AEHomeSectionItem yy_modelWithDictionary:@{@"image":@"home_hot_exam",@"title":@"热门考试",@"isExpand":@1,@"backgroundColor":@"FBAB53"}];
        }
        [self.dataSources addObject:item];
    }
    WS(weakSelf)
    [self createTableViewStyle:UITableViewStyleGrouped];
    self.tableView.frame = CGRectMake(0, ySpace, SCREEN_WIDTH, SCREEN_HEIGHT  - TAB_BAR_HEIGHT  - ySpace);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = AEColorLine;
    self.tableView.tableHeaderView = self.headerView;
    [self addHeaderRefesh:NO Block:^{
        [weakSelf afterProFun];
    }];
}

-(void)afterProFun {
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    __block NSInteger isEnd = - 3; //控制请求是否完成
    
    //我的考试数据 未登录不需要请求
    if (User.isLogin) {
        [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kHomeMyExam query:nil path:nil body:nil success:^(id object) {
            isEnd += 1;
            AEHomeModuleItem * item = weakSelf.dataSources[0];
            item.data = [NSArray yy_modelArrayWithClass:[AEExamItem class] json:object].mutableCopy;
            [weakSelf.dataSources replaceObjectAtIndex:0 withObject:item];
            [weakSelf endLoadData:isEnd];
        } faile:^(NSInteger code, NSString *error) {
            isEnd += 1;
            [weakSelf endLoadData:isEnd];
            [AEBase alertMessage:error cb:nil];
        }];
    }else {
        isEnd += 1;
    }
    //热门考试
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kRecommendSubjectList query:nil path:nil body:nil success:^(id object) {
        isEnd += 1;
        AEHomeModuleItem * item = weakSelf.dataSources[1];
        item.data = [NSArray yy_modelArrayWithClass:[AEExamItem class] json:object].mutableCopy;
        [weakSelf.dataSources replaceObjectAtIndex:1 withObject:item];
        [weakSelf endLoadData:isEnd];
    } faile:^(NSInteger code, NSString *error) {
        isEnd += 1;
        [weakSelf endLoadData:isEnd];
        [AEBase alertMessage:error cb:nil];
    }];
    //banner图数据
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kBanner query:nil path:nil body:nil success:^(id object) {
        isEnd += 1;
        if ([object isKindOfClass:[NSArray class]]) {
            //轮播图
            if ([object count] > 0) {
                [weakSelf.headerView updateBanner:object];
            }else {
                //加载本地储存banner
                [weakSelf.headerView updateBanner:@[[UIImage imageNamed:@"banner0"],[UIImage imageNamed:@"banner1"]]];
            }
        }
        [weakSelf endLoadData:isEnd];
    } faile:^(NSInteger code, NSString *error) {
        isEnd += 1;
        [weakSelf endLoadData:isEnd];
        [AEBase alertMessage:error cb:nil];
    }];
}
- (void)endLoadData:(NSInteger)isEnd {
    if (isEnd >= 0) {
        [self hudclose];
        [self endRefesh:YES];
        [self.tableView reloadData];
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSources.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AEHomeModuleItem * item = self.dataSources[section];
    if (item.sectionItem.isExpand) {
        return item.data.count;
    }else { //不展开显示0
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEHomePageCell * cell = [AEHomePageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WS(weakSelf)
    AEHomeModuleItem * item = self.dataSources[indexPath.section];
    [cell updateCell:item.data[indexPath.row]];
    cell.buyBlock = ^{
        [weakSelf pushOrderDetailVC:item.data[indexPath.row]];
    };
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __block __weak typeof(AEHomeModuleItem *) item = self.dataSources[section];
    __block __weak AEHomeSectionItem * sectionItem = item.sectionItem;
    if (item.data.count > 0) {
        AEHomeSectionView * sectionView = [[NSBundle mainBundle]loadNibNamed:@"AEHomeSectionView" owner:nil options:nil].firstObject;
        sectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        [sectionView updateSectionView:sectionItem];
        //展开
        WS(weakSelf)
        sectionView.expandBlock = ^{
            sectionItem.isExpand = !sectionItem.isExpand;
            [weakSelf.dataSources replaceObjectAtIndex:section withObject:item];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        };
        return sectionView;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    AEHomeModuleItem * item = self.dataSources[section];
    return item.data.count > 0 ? 30.f : 0.00000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AEHomeModuleItem * item = self.dataSources[indexPath.section];
    [self pushOrderDetailVC:item.data[indexPath.row]];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(separatorInset)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
//MARK: 订单详情
- (void)pushOrderDetailVC:(AEExamItem *)item {
    AEOrderDetailVC * VC = [AEOrderDetailVC new];
    VC.item = item;
    VC.payStatus = AEOrderAffirmPay;
    PUSHLoginCustomViewController(VC, self);
}
//MARK: 通知列表
- (void)gotoNoticeDetail {
    AECustomSegmentVC * customVC = [AECustomSegmentVC new];
    customVC.baseTopView.titleName = @"通知";
    AEMessageListVC * unReadMessageVC = [[AEMessageListVC alloc] init];
    unReadMessageVC.messageType = UnReadMessageListType;
    AEMessageListVC *readMessageVC = [[AEMessageListVC alloc] init];
    readMessageVC.messageType = ReadMessageListType;
    [customVC setupPageView:@[@"未读", @"已读"] ContentViewControllers:@[unReadMessageVC, readMessageVC]];
    PUSHLoginCustomViewController(customVC, self)
}
#pragma mark - 懒加载
-(AEHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"AEHomeHeaderView" owner:nil options:nil].firstObject;
        //图片宽高比
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9/16);
    }
    return _headerView;
}

-(AEHomeNoticeIconView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[AEHomeNoticeIconView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    return _noticeView;
}


@end
