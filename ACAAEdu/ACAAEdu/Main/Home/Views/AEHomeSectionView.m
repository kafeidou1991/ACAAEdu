//
//  AEHomeSectionView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2019/1/17.
//  Copyright © 2019 ACAA. All rights reserved.
//

#import "AEHomeSectionView.h"
#import "AEHomeModuleItem.h"

@implementation AEHomeSectionView {
    __weak IBOutlet UIImageView *leftImageView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIButton *rightBtn;
}

- (void)setType:(AESectionType)type {
    _type = type;
    if (_type == AEACAASectionType) {
        leftImageView.image = [UIImage imageNamed:@"acaa_categaory_exam"];
        titleLabel.textColor = AEHexColor(@"1D1D27");
        self.backgroundColor = AEHexColor(@"E4E5E6");
        [rightBtn setImage:[UIImage imageNamed:@"acaa_exam_close"] forState:UIControlStateSelected];
        [rightBtn setImage:[UIImage imageNamed:@"acaa_exam_open"] forState:UIControlStateNormal];
    }
}
//首页分区
- (void)updateSectionView:(AEHomeSectionItem *)item {
    leftImageView.image = [UIImage imageNamed:item.image];
    titleLabel.text = item.name;
    rightBtn.selected = item.isExpand;
    self.backgroundColor = AEHexColor(item.backgroundColor);
}

//acaa分区分类
- (void)updateACAACategaoryView:(AEAcaaCategoryItem *)item {
    titleLabel.text = item.name;
    rightBtn.selected = item.isExpand;
}

- (IBAction)expandAction:(UIButton *)sender {
    if (_expandBlock) {
        _expandBlock();
    }
}




@end
