//
//  AEACAAExamVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2019/1/21.
//  Copyright © 2019 ACAA. All rights reserved.
//

#import "AEACAAExamVC.h"
#import "AEHomePageCell.h"
#import "AEOrderDetailVC.h"
#import "AEScreeningVC.h"
#import "AESearchExamVC.h"
#import "AEHomeSectionView.h"

@interface AEACAAExamVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@end

@implementation AEACAAExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topViewHeight.constant = NAVIGATION_HEIGHT;
    [self initComponent];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afterProFun) name:kPayOrderSuccess object:nil];
}
#pragma mark - 搜索
- (IBAction)searchExam:(id)sender {
    AESearchExamVC * searchVC = [AESearchExamVC new];
    searchVC.examType = AEExamACAAType;
    PUSHCustomViewController(searchVC, self);
}
- (void)initComponent {
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT- TAB_BAR_HEIGHT);
    WS(weakSelf)
    [weakSelf addHeaderRefesh:NO Block:^{
        [weakSelf loadData:NO];
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
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kAcaaList query:nil path:nil body:nil success:^(id object) {
        isLoad ? [weakSelf hudclose] : nil;
        [weakSelf endRefesh:YES];
        weakSelf.dataSources = [NSArray yy_modelArrayWithClass:[AEAcaaCategoryItem class] json:object].mutableCopy;
        if (weakSelf.dataSources.count > 0) {
            //第一项默认展开
            AEAcaaCategoryItem * item = weakSelf.dataSources[0];
            item.isExpand = YES;
        }
        [weakSelf.tableView reloadData];
    } faile:^(NSInteger code, NSString *error) {
        isLoad ? [weakSelf hudclose] : nil;
        [weakSelf endRefesh:YES];
        [AEBase alertMessage:error cb:nil];
    }];
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSources.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AEAcaaCategoryItem * item = self.dataSources[section];
    if (item.isExpand) {
        return item.subject.count;
    }else { //不展开显示0
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEHomePageCell * cell = [AEHomePageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WS(weakSelf)
    AEAcaaCategoryItem * item = self.dataSources[indexPath.section];
    [cell updateCell:item.subject[indexPath.row]];
    //点击购买
    cell.buyBlock = ^{
        [weakSelf pushOrderDetailVC:item.subject[indexPath.row]];
    };
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __block __weak typeof(AEAcaaCategoryItem *) item = self.dataSources[section];
    AEHomeSectionView * sectionView = [[NSBundle mainBundle]loadNibNamed:@"AEHomeSectionView" owner:nil options:nil].firstObject;
    sectionView.type = AEACAASectionType;
    sectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    [sectionView updateACAACategaoryView:item];
    //展开
    WS(weakSelf)
    sectionView.expandBlock = ^{
        item.isExpand = !item.isExpand;
        [weakSelf.dataSources replaceObjectAtIndex:section withObject:item];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    };
    return sectionView;
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footView.backgroundColor = [UIColor whiteColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    AEAcaaCategoryItem * item = self.dataSources[section];
    return 30.f;//item.subject.count > 0 ? 30.f : 0.00000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AEAcaaCategoryItem * item = self.dataSources[indexPath.section];
    [self pushOrderDetailVC:item.subject[indexPath.row]];
}

- (void)pushOrderDetailVC:(AEExamItem *)item {
    AEOrderDetailVC * VC = [AEOrderDetailVC new];
    VC.item = item;
    VC.payStatus = AEOrderAffirmPay;
    PUSHLoginCustomViewController(VC, self);
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
