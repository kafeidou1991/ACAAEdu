//
//  AEHomeSectionView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2019/1/17.
//  Copyright © 2019 ACAA. All rights reserved.
//

#import "AEHomeSectionView.h"

@implementation AEHomeSectionView {
    __weak IBOutlet UIImageView *leftImageView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIButton *rightBtn;
}

- (void)updateSectionView:(NSDictionary *)dict {
    leftImageView.image = [UIImage imageNamed:dict[@"image"]];
    titleLabel.text = dict[@"title"];
    rightBtn.selected = [dict[@"isExpand"]intValue];
    self.backgroundColor = AEHexColor(dict[@"backgroundColor"]);
}


- (IBAction)expandAction:(UIButton *)sender {
    if (_expandBlock) {
        _expandBlock();
    }
}




@end
