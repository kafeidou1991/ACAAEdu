//
//  WLSpecScaleLayoutConstrain.m
//  WeiLicai
//
//  Created by zhoushengjian on 2017/5/25.
//  Copyright © 2017年 WeiliCai. All rights reserved.
//

#import "WLSpecScaleLayoutConstrain.h"

@implementation WLSpecScaleLayoutConstrain

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat scale = SPECIAL_SCALE;
    self.constant = ceilf(self.constant * scale);
    
}

@end
