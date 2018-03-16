//
//  AEMyOrderCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEMyOrderCell.h"

@interface AEMyOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

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

- (void)updateCell:(AEGoodItem *)item hiddenTitle:(BOOL)isHidden{
    self.titleLabel.hidden = isHidden;
    self.contentLabel.text = item.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",item.goods_price];
}



@end
