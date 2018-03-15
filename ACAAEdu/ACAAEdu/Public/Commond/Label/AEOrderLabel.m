//
//  AEOrderLabel.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEOrderLabel.h"

static const CGFloat labelWidth = 75.f;

@interface AEOrderLabel ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * desLabel;

@end

@implementation AEOrderLabel

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.desLabel];
    }
    return self;
}

- (void)updateTitle:(NSString *)title content:(NSString *)des {
    self.titleLabel.text = title;
    self.desLabel.text = des;
}


-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [AEBase createLabel:CGRectMake(0, 0, labelWidth, self.height) font:[UIFont systemFontOfSize:14] text:@"" defaultSizeTxt:@"" color:AEHexColor(@"333333") backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

-(UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [AEBase createLabel:CGRectMake(_titleLabel.right + 5, 0, self.width - labelWidth, self.height) font:[UIFont systemFontOfSize:14] text:@"" defaultSizeTxt:@"" color:AEHexColor(@"666666") backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
    }
    return _desLabel;
}


@end
