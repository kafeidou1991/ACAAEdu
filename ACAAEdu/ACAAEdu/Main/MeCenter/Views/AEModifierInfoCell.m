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
    NSString * value = dict[@"value"];
    if (!STRISEMPTY(value)) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@\n%@",dict[@"title"],value];
        self.functionBtn.selected = YES;
    }else {
        self.titleLabel.text = dict[@"title"];
        self.functionBtn.selected = NO;
    }
//    if ([dict[@"title"] isEqualToString:@"身份证账号"] && !STRISEMPTY(User.id_card)) {
//        self.functionBtn.hidden = YES;
//    }else {
//        self.functionBtn.hidden = NO;
//    }
}
- (IBAction)functionClick:(UIButton *)sender {
    if (_actionBlock) {
        _actionBlock();
    }
}

@end
