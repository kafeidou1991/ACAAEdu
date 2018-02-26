//
//  AEUserInfoCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/19.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEModifierInfoCell.h"

@interface AEModifierInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;

@end

@implementation AEModifierInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
-(void)updateCell:(NSDictionary *)dict {
    self.titleLabel.text = dict[@"title"];
    self.contentLabel.text = dict[@"value"];
    if (!STRISEMPTY(dict[@"value"])) {
        [self.functionBtn setTitle:@"解绑" forState:UIControlStateNormal];
    }else {
        [self.functionBtn setTitle:@"绑定" forState:UIControlStateNormal];
    }
    if ([dict[@"title"] isEqualToString:@"身份证账号"] && !STRISEMPTY(User.id_card)) {
        self.functionBtn.hidden = YES;
    }else {
        self.functionBtn.hidden = NO;
    }
}
- (IBAction)functionClick:(UIButton *)sender {
    
    
}

@end
