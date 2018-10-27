//
//  AEUserInfoVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/19.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEUserInfoVC.h"
#import "AEUserInfoCell.h"
#import "CGXPickerView.h"
#import "AEUserRemarkCell.h"

@interface AEUserInfoVC ()<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
/**
 pickview 字体颜色等
 */
@property (nonatomic, strong) CGXPickerViewManager * pickViewManage;
/**
 用户资料
 */
@property (nonatomic, strong) AEUserProfile * info;

@end

@implementation AEUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTopView];
    self.baseTopView.titleName = @"个人资料";
    [self addSaveButton];
}
-(void)afterProFun {
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kGetProfile query:nil path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
        weakSelf.info = [AEUserProfile yy_modelWithJSON:object[@"user_profile"]];
        //服务器返回时间戳 单独处理下
        weakSelf.info.birthday = [NSString dateToStringFormatter:@"yyyy-MM-dd" date:[NSDate dateWithTimeIntervalSince1970:weakSelf.info.birthday.integerValue]];
        [weakSelf reloadDataSources];
        [weakSelf createTableViewStyle:UITableViewStylePlain];
        
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
#pragma mark - 上传表单
- (void)save {
    [self.view endEditing:YES];
    NSMutableDictionary * pramaDict = @{}.mutableCopy;
    //英文名 性别  必传
    if (STRISEMPTY(_info.user_name_en)) {
        [AEBase alertMessage:@"请填入英文名!" cb:nil];
        return;
    }
    [pramaDict setObject:_info.user_name_en forKey:@"user_name_en"];
    
    if (!STRISEMPTY(_info.birthday)) {
        [pramaDict setObject:_info.birthday forKey:@"birthday"];
    }
    
    if (STRISEMPTY(_info.gender)) {
        [AEBase alertMessage:@"请选择性别!" cb:nil];
        return;
    }
    [pramaDict setObject:_info.gender forKey:@"gender"];
    
    if (!STRISEMPTY(_info.province)) {
        [pramaDict setObject:_info.province forKey:@"province"];
    }
    if (!STRISEMPTY(_info.city)) {
        [pramaDict setObject:_info.city forKey:@"city"];
    }
    if (!STRISEMPTY(_info.address)) {
        [pramaDict setObject:_info.address forKey:@"address"];
    }
    if (!STRISEMPTY(_info.post_code)) {
        [pramaDict setObject:_info.post_code forKey:@"post_code"];
    }
    if (!STRISEMPTY(_info.phone_num)) {
        [pramaDict setObject:_info.phone_num forKey:@"phone_num"];
    }
    if (!STRISEMPTY(_info.vocation)) {
        [pramaDict setObject:_info.vocation forKey:@"vocation"];
    }
    if (!STRISEMPTY(_info.fax_num)) {
        [pramaDict setObject:_info.fax_num forKey:@"fax_num"];
    }
    if (!STRISEMPTY(_info.edu_level)) {
        [pramaDict setObject:_info.edu_level forKey:@"edu_level"];
    }
    if (!STRISEMPTY(_info.remark)) {
        [pramaDict setObject:_info.remark forKey:@"remark"];
    }
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kProfile query:nil path:nil body:pramaDict success:^(id object) {
        [weakSelf hudclose];
        [AEBase alertMessage:@"恭喜你，完善成功" cb:nil];
        [weakSelf updateSuccess:object];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
    
}
- (void)updateSuccess:(id)object {
    _info = [AEUserProfile yy_modelWithDictionary:object];
    //服务器返回时间戳 单独处理下
    _info.birthday = [NSString dateToStringFormatter:@"yyyy-MM-dd" date:[NSDate dateWithTimeIntervalSince1970:_info.birthday.integerValue]];
    User.user_profile = _info;
    [User save];
    [self reloadDataSources];
    [self.tableView reloadData];
}
#pragma mark -刷新数据源
- (void)reloadDataSources {
    self.dataSources = @[@{@"title":@"英文名",@"value":_info.user_name_en},
                         @{@"title":@"生日",@"value":STRISEMPTY(_info.birthday) ? @"" : _info.birthday},
                         @{@"title":@"性别",@"value":[self toString:_info.gender]},
                         @{@"title":@"所在地",@"value":STRISEMPTY(_info.province) ? @"" : [NSString stringWithFormat:@"%@ %@",_info.province,_info.city]},
                         @{@"title":@"详细地址",@"value":_info.address},
                         @{@"title":@"邮政编码",@"value":_info.post_code},
                         @{@"title":@"电话号码",@"value":_info.phone_num},
                         @{@"title":@"传真号码",@"value":_info.fax_num},
                         @{@"title":@"职业",@"value":_info.vocation},
                         @{@"title":@"学历",@"value":_info.edu_level},
                         @{@"title":@"个人简介:",@"value":_info.remark}].mutableCopy;
}
#pragma mark - tableview delegate & datesource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dict = self.dataSources[indexPath.row];
    if (indexPath.row != 10) {
        AEUserInfoCell * cell = [AEUserInfoCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell updateCell:dict];
        [self textFieldPlacehold:indexPath Cell:cell];
        return cell;
    }else {
        AEUserRemarkCell * cell = [AEUserRemarkCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell updateCell:dict];
        cell.contentTextView.delegate = self;
        return cell;
    }
}
- (void)textFieldPlacehold:(NSIndexPath *)indexPath Cell:(AEUserInfoCell *)cell {
    if (indexPath.row == 0 || indexPath.row == 4 ||indexPath.row == 5 ||indexPath.row == 6 || indexPath.row == 7) {
        cell.contentTextField.placeholder = @"请输入";
        cell.contentTextField.enabled =YES;
    }else {
        cell.contentTextField.placeholder = @"请选择";
        cell.contentTextField.enabled = NO;
    }
    cell.contentTextField.delegate = self;
    cell.contentTextField.tag = indexPath.row;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 10 ? RemarkHeight : 50.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self birthday];
    }else if (indexPath.row == 2) {
        [self gender];
    }else if (indexPath.row == 3) {
        [self province];
    }else if (indexPath.row == 8) {
        [self vocation];
    }else if (indexPath.row == 9) {
        [self eduLevel];
    }else if (indexPath.row == 10) {
        AEUserRemarkCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
        if ([cell.contentTextView canBecomeFirstResponder]) {
            [cell.contentTextView becomeFirstResponder];
        }
    }
}
#pragma mark - 处理事件
//生日
- (void)birthday {
    WS(weakSelf);
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *nowStr = [fmt stringFromDate:now];
    [CGXPickerView showDatePickerWithTitle:@"生日" DateType:UIDatePickerModeDate DefaultSelValue:STRISEMPTY(_info.birthday) ? nil : _info.birthday MinDateStr:@"1900-01-01 00:00:00" MaxDateStr:nowStr IsAutoSelect:NO Manager:self.pickViewManage ResultBlock:^(NSString *selectValue) {
        _info.birthday = selectValue;
        AEUserInfoCell * cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.contentTextField.text = selectValue;
        cell.leftImageView.hidden = NO;
        [weakSelf reloadDataSources];
    }];
}
//性别
- (void)gender {
    WS(weakSelf);
    [CGXPickerView showStringPickerWithTitle:@"性别" DataSource:@[@"女", @"男", @"保密"] DefaultSelValue:STRISEMPTY([self toString:_info.gender]) ? nil :[self toString:_info.gender] IsAutoSelect:NO Manager:self.pickViewManage ResultBlock:^(id selectValue, id selectRow) {
        _info.gender = (NSString *)selectRow;
        AEUserInfoCell * cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.contentTextField.text = [weakSelf toString:_info.gender];
        cell.leftImageView.hidden = NO;
        [weakSelf reloadDataSources];
    }];
}
//省市
- (void)province {
    WS(weakSelf);
    [CGXPickerView showAddressPickerWithTitle:@"请选择你的省市" DefaultSelected:@[@0,@0] IsAutoSelect:NO Manager:self.pickViewManage ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
        NSLog(@"%@-%@",selectAddressArr,selectAddressRow);
        _info.province = selectAddressArr[0];
        _info.city = selectAddressArr[1];
        AEUserInfoCell * cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.contentTextField.text = [NSString stringWithFormat:@"%@ %@",_info.province,_info.city];
        cell.leftImageView.hidden = NO;
        [weakSelf reloadDataSources];
    }];
}
//职业
- (void)vocation {
    WS(weakSelf);
    [CGXPickerView showStringPickerWithTitle:@"职业" DataSource:@[@"学生", @"教师", @"设计",@"工程师",@"管理人员",@"其他"] DefaultSelValue:STRISEMPTY(_info.vocation) ? nil : _info.vocation IsAutoSelect:NO Manager:self.pickViewManage ResultBlock:^(id selectValue, id selectRow) {
        _info.vocation = (NSString *)selectValue;
        AEUserInfoCell * cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
        cell.contentTextField.text = _info.vocation;
        cell.leftImageView.hidden = NO;
        [weakSelf reloadDataSources];
    }];
}
//学历
- (void)eduLevel {
    WS(weakSelf);
    [CGXPickerView showStringPickerWithTitle:@"学历" DataSource:@[@"高中", @"大专", @"本科",@"学士",@"硕士",@"博士"] DefaultSelValue:STRISEMPTY(_info.edu_level) ? nil : _info.edu_level IsAutoSelect:NO Manager:self.pickViewManage ResultBlock:^(id selectValue, id selectRow) {
        _info.edu_level = (NSString *)selectValue;
        AEUserInfoCell * cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
        cell.contentTextField.text = _info.edu_level;
        cell.leftImageView.hidden = NO;
        [weakSelf reloadDataSources];
    }];
}
#pragma mark - textField delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //0 4 5 6 7 10
    NSString * beString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 0) {
        _info.user_name_en = beString;
    }else if (textField.tag == 4) {
        _info.address = beString;
    }else if (textField.tag == 5) {
        _info.post_code = beString;
    }else if (textField.tag == 6) {
        _info.phone_num = beString;
    }else if (textField.tag == 7) {
        _info.fax_num = beString;
    }
    [self reloadDataSources];
    AEUserInfoCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    if (cell) {
        cell.leftImageView.hidden = STRISEMPTY(beString);
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString * beString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    _info.remark = beString;
    [self reloadDataSources];
    return YES;
}


//init
-(CGXPickerViewManager *)pickViewManage {
    if (!_pickViewManage) {
        _pickViewManage = [CGXPickerViewManager new];
        _pickViewManage.leftBtnTitleColor = _pickViewManage.rightBtnTitleColor = [UIColor whiteColor];
        _pickViewManage.titleLabelColor = AEColorLightText;
        _pickViewManage.leftBtnBGColor = _pickViewManage.leftBtnborderColor = AEHexColor(@"E7E8EA");
        _pickViewManage.rightBtnBGColor = _pickViewManage.rightBtnborderColor = AEThemeColor;
    }
    return _pickViewManage;
}
-(AEUserProfile *)info {
    if (!_info) {
        _info = [AEUserProfile new];
    }
    return _info;
}
- (void)addSaveButton {
    UIButton * btn = [AEBase createButton:CGRectZero type:UIButtonTypeCustom title:@"保存"];
    btn.layer.cornerRadius = 25.f;
    btn.backgroundColor = AEThemeColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.baseTopView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-30);
    }];
}
- (NSString *)toString:(NSString *)gender {
    if (STRISEMPTY(gender)) {
        return @"";
    }
    NSString * s = @"";
    if (gender.integerValue == 0) {
        s = @"女";
    }else if (gender.integerValue == 1) {
        s = @"男";
    }else {
        s = @"保密";
    }
    return s;
}
@end
