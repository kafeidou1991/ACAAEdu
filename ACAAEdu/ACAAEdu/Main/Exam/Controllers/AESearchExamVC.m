//
//  AESearchExamVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/10.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AESearchExamVC.h"
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
    [self createTableViewStyle:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:_examType == AEExamACAAType ? kAcaaSearchList : kAutodeskList query:self.pararsDict path:nil body:nil success:^(id object) {
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AEHomePageCell * cell = [AEHomePageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WS(weakSelf)
    [cell updateCell:self.dataSources[indexPath.row]];
    //点击购买
    cell.buyBlock = ^{
        [weakSelf pushOrderDetailVC:weakSelf.dataSources[indexPath.row]];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushOrderDetailVC:self.dataSources[indexPath.row]];
}
- (void)pushOrderDetailVC:(AEExamItem *)item {
    AEOrderDetailVC * VC = [AEOrderDetailVC new];
    VC.item = item;
    VC.payStatus = AEOrderAffirmPay;
    PUSHLoginCustomViewController(VC, self);
}
//MARK: 初始化titleView
- (void)setupTitleView{
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.titleView = [self createNavigationView];
    self.navigationItem.rightBarButtonItem = [self createCustomBarButtonItem:self action:@selector(pop) title:@" 取消"];
}

- (UIView *)createNavigationView
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 32)];
    navigationView.backgroundColor = [UIColor whiteColor];
    navigationView.layer.cornerRadius = 2;
    navigationView.layer.masksToBounds = YES;
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, navigationView.width- 10, navigationView.height)];
    searchTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.font = [UIFont systemFontOfSize:14.0f];
    searchTextField.textColor = AEColorLightText;
    searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeDefault;
    searchTextField.delegate = self;
    searchTextField.leftView = [self createLeftSearchView];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.placeholder = @"请输入关键词";
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
- (UIBarButtonItem *)createCustomBarButtonItem:(id)target action:(SEL)action title:(NSString *)title
{
    if (STRISEMPTY(title)) {
        return nil;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16.f];
    CGSize size = STR_FONT_SIZE(title,200, button.titleLabel.font);
    button.frame=CGRectMake(0, 0, size.width, size.height+10.f);
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}
- (void)pop{
    if ([_textField canResignFirstResponder]) {
        [_textField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
