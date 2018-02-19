//
//  AEUserInfoCell.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/19.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEUserInfoCell.h"

@interface AEUserInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;

@end

@implementation AEUserInfoCell

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
    NSString * status = dict[@"status"];
    if (status.boolValue) {
        [self.functionBtn setTitle:@"解绑" forState:UIControlStateNormal];
    }else {
        [self.functionBtn setTitle:@"绑定" forState:UIControlStateNormal];
    }
}
- (IBAction)functionClick:(UIButton *)sender {
    
    
}

@end
