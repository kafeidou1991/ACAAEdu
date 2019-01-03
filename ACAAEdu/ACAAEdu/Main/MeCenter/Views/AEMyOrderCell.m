//
//  AEMyOrderCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyOrderCell.h"
#import "AEExamItem.h"

@interface AEMyOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;

@end

@implementation AEMyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(AEGoodItem *)item{
    self.titleLabel.text = item.goods_name;
    self.versionLabel.text = [NSString stringWithFormat:@"版本:%@",item.goods_attr_data.version];
    self.cateLabel.text = [NSString stringWithFormat:@"类别:%@",item.goods_attr_data.subject_type_name];
}



@end
