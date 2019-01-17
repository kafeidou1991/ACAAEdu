//
//  CollectionViewCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEHomePageCell.h"

@interface AEHomePageCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn; //购买按钮
@property (weak, nonatomic) IBOutlet UILabel *orginPriceLabel; //原始价格


@end

@implementation AEHomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)updateCell:(AEExamItem *)item {
    [self setContentText:item];
}


- (void)setMyExamContentText:(AEMyExamItem *)item {
    self.nameLabel.text = item.subject.subject_full_name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",item.subject.subject_price];
}

- (void)setContentText:(AEExamItem *)item {
    self.nameLabel.text = item.subject_full_name;
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",item.subject_realPrice];
//    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:STRISEMPTY(item.subject_price) ? @"￥0":[NSString stringWithFormat:@"￥%@",item.subject_price] attributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
//    self.orginPriceLabel.attributedText = attStr;
}

- (IBAction)buyAction:(UIButton *)sender {
    if (_buyBlock) {
        _buyBlock();
    }
}


@end
