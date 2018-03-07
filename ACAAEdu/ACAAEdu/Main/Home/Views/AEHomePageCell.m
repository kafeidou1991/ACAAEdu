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
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation AEHomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)updateCell:(AEExamItem *)item {
//    self.nameLabel.text = item.subject_full_name;
//    self.versionLabel.text = [NSString stringWithFormat:@"版本：%@",item.version];
//    self.categoryLabel.text = [NSString stringWithFormat:@"类别：%@",item.subject_name];
//    self.categoryLabel.text = [NSString stringWithFormat:@"类别：%@",item.subject_name];
    
}

- (IBAction)buyAction:(UIButton *)sender {
    if (_buyBlock) {
        _buyBlock();
    }
}

@end
