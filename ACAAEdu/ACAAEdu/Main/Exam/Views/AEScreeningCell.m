//
//  AEScreeningCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/14.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEScreeningCell.h"

@interface AEScreeningCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AEScreeningCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)updateSubjectCell:(AEScreeningItem *)item {
    self.titleLabel.text = item.subject_type_name;
    [self selectLabel:item.isSelect];
}
- (void)updateCategoryCell:(AEScreeningItem *)item {
    self.titleLabel.text = item.name;
    [self selectLabel:item.isSelect];
}
- (void)updateVersionCell:(AEScreeningItem *)item {
    self.titleLabel.text = item.version;
    [self selectLabel:item.isSelect];
}

- (void)selectLabel:(BOOL)isSelect {
    self.titleLabel.backgroundColor = isSelect ? AEThemeColor : AEHexColor(@"CECECE");
    self.titleLabel.textColor = isSelect ? [UIColor whiteColor] :AEHexColor(@"333333");
}




@end
