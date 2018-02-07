//
//  WLScaleLayoutConstrain.m
//  WeiLicai
//
//  Created by zhoushengjian on 17/1/9.
//  Copyright © 2017年 WeiliCai. All rights reserved.
//

#import "WLScaleLayoutConstrain.h"

@implementation WLScaleLayoutConstrain

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat scale = MAIN_SCALE;
    self.constant = ceilf(self.constant * scale);

}

@end
