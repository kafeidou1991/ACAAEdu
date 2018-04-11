//
//  AESearchExamVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/10.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AESearchExamVC.h"
#import "AEExamItem.h"
#import "AEHomePageCell.h"
#import "AEOrderDetailVC.h"

@interface AESearchExamVC () <UITextFieldDelegate>{
    UITextField *_textField;
}
/**
 请求参数
 */
@property (nonatomic, strong) NSMutableDictionary * pararsDict;

@end

@implementation AESearchExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleView];
    self.pararsDict = @{@"page" : @(self.currPage)}.mutableCopy;
    [self createTableViewStyle:UITableViewStyleGrouped];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (STRISEMPTY(textField.text.trimString)) {
        [AEBase alertMessage:@"请输入您要搜索的关键词" cb:nil];
        return NO;
    }
    [self.pararsDict setObject:textField.text forKey:@"keyWord"];
    [self loadData:YES];
    return YES;
}
//MARK: 数据
- (void)loadData:(BOOL)isLoad {
    if ([_textField canResignFirstResponder]) {
        [_textField resignFirstResponder];
    }
    if (isLoad) {
        [self hudShow:self.view msg:STTR_ater_on];
    }
    WS(weakSelf);
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kIndexList query:self.pararsDict path:nil body:nil success:^(id object) {
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
                [AEBase alertMessage:@"没有搜索数据" cb:nil];
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
    [cell updateCell:self.dataSources[indexPath.section]];
    //点击购买
    cell.buyBlock = ^{
        [weakSelf pushOrderDetailVC:@[weakSelf.dataSources[indexPath.section]]];
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
    [self pushOrderDetailVC:@[self.dataSources[indexPath.section]]];
}
- (void)pushOrderDetailVC:(NSArray *)data {
    AEOrderDetailVC * VC = [AEOrderDetailVC new];
    [VC loadData:data];
    PUSHLoginCustomViewController(VC, self);
}
//MARK: 初始化titleView
- (void)setupTitleView{
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.titleView = [self createNavigationView];
    self.navigationItem.rightBarButtonItem = [AEBase createCustomBarButtonItem:self action:@selector(pop) title:@" 取消"];
}

- (UIView *)createNavigationView
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 32)];
    navigationView.backgroundColor = [UIColor whiteColor];
    navigationView.layer.cornerRadius = 2;
    navigationView.layer.masksToBounds = YES;
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, navigationView.width-5, navigationView.height)];
    searchTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.font = [UIFont systemFontOfSize:14.0f];
    searchTextField.textColor = AEColorLightText;
    searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeDefault;
    searchTextField.delegate = self;
    searchTextField.leftView = [self createLeftSearchView];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.placeholder = @"搜索考试";
    searchTextField.tintColor       = [UIColor blueColor];
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.rightViewMode   = UITextFieldViewModeWhileEditing;
    _textField = searchTextField;
    [navigationView addSubview:searchTextField];
    return navigationView;
}
- (UIView *)createLeftSearchView{
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 42)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchImage"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(10, 5, 20, 32);
    [leftView addSubview:imageView];
    return leftView;
}
- (void)pop{
    if ([_textField canResignFirstResponder]) {
        [_textField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
