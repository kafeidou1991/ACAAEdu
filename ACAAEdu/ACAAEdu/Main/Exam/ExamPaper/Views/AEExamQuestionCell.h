//
//  AEExamQuestionCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEExamQuestionCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *optionLabel; //选项
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;//选择
@property (weak, nonatomic) IBOutlet UILabel *questionLabel; //题干

- (void)updateCell:(AEQuestionRresult *)result index:(NSInteger)index;
/**
 是否选择了题

 @param isSelect 选择
 */
- (void)select:(BOOL)isSelect;

@end
