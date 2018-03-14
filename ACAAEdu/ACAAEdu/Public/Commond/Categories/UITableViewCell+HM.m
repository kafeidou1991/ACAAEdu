//
//  UITableViewCell+HM.m
//  IHaoMu
//
//  Created by zhoushengjian on 16/11/7.
//  Copyright © 2016年 ihaomu.com. All rights reserved.
//

#import "UITableViewCell+HM.h"

@implementation UITableViewCell (HM)

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
