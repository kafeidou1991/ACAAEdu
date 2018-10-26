//
//  AEUserInfoCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/23.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEUserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet AETextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIImageView * leftImageView;

- (void)updateCell:(NSDictionary * )dict;

@end
