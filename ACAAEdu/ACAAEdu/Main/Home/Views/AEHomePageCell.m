//
//  CollectionViewCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEHomePageCell.h"
#import "AEExamItem.h"

@interface AEHomePageCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn; //多选按钮
@property (weak, nonatomic) IBOutlet UIButton *buyBtn; //购买按钮


@end

@implementation AEHomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)updateCell:(AEExamItem *)item {
    [self setContentText:item];
    self.buyBtn.hidden = NO;
    self.moreBtn.hidden = YES;
    
}
-(void)updateMoreCell:(AEExamItem *)item {
    [self setContentText:item];
    self.buyBtn.hidden = YES;
    self.moreBtn.hidden = NO;
    self.moreBtn.selected = item.isSelect;
}

- (void)updateMyTestExamCell:(AEExamItem *)item done:(BOOL)done {
    [self setContentText:item];
    self.buyBtn.hidden = NO;
    self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.buyBtn setTitle:done ? @"查看成绩" : @"开始考试" forState:UIControlStateNormal];
    self.moreBtn.hidden = YES;
    self.priceLabel.hidden = YES;
}

- (void)setContentText:(AEExamItem *)item {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",item.short_name.length > 0 ? [item.short_name substringToIndex:1] : @""];
    self.nameLabel.text = item.subject_full_name;
    self.versionLabel.text = [NSString stringWithFormat:@"版本：%@",item.version];
    self.categoryLabel.text = [NSString stringWithFormat:@"类别：%@",item.short_name];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",item.subject_price];
}

- (IBAction)buyAction:(UIButton *)sender {
    if (_buyBlock) {
        _buyBlock();
    }
}
//更多点击
- (IBAction)moreAction:(UIButton *)sender {
    if (_moreBlock) {
        _moreBlock(sender);
    }
}

@end
