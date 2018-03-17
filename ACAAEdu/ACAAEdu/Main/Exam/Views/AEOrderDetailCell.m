//
//  AEOrderDetailCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/13.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEOrderDetailCell.h"
#import "AEExamItem.h"

@interface AEOrderDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation AEOrderDetailCell

-(void)updateCell:(AEExamItem *)item {
    [self setContentText:item];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentText:(AEExamItem *)item {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",item.short_name.length > 0 ? [item.short_name substringToIndex:1] : @""];
    self.nameLabel.text = item.subject_full_name;
    self.versionLabel.text = [NSString stringWithFormat:@"版本：%@",item.version];
    self.categoryLabel.text = [NSString stringWithFormat:@"类别：%@",item.short_name];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",item.subject_price];
}

@end
