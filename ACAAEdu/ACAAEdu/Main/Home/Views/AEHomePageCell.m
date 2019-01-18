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


//考试类别  默认 隐藏
@property (weak, nonatomic) IBOutlet UIImageView *examTypeImageView;


@end

@implementation AEHomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
/**
 考试列表单选模式
 
 @param item 数据
 */
-(void)updateCell:(AEExamItem *)item {
    [self setContentText:item];
    self.examTypeImageView.hidden = YES;
    [self.buyBtn setImage:[UIImage imageNamed:@"home_has_buy"] forState:UIControlStateNormal];
}
/**
 首页我的考试
 
 @param item 数据
 */
- (void)updateHomeMyExamCell:(AEMyExamItem *)item {
    [self setContentText:item.subject];
    self.examTypeImageView.hidden = NO;
    self.examTypeImageView.image = [UIImage imageNamed:[item.subject.subject_institute isEqualToString:@"1"]? @"home_exam_acaa": @"home_exam_adsk"];
    [self.buyBtn setImage:[UIImage imageNamed:@"home_myexam_goto"] forState:UIControlStateNormal];
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
