//
//  AEUserRemarkCell.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>
//个人简介
#define RemarkHeight 120.f
@interface AEUserRemarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

-(void)updateCell:(NSDictionary *)dict;

@end
