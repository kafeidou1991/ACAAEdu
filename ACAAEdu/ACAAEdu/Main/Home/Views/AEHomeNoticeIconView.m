//
//  AEHomeNoticeIconView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/10/27.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEHomeNoticeIconView.h"

@interface AEHomeNoticeIconView ()
@property (nonatomic, strong) UIImageView * centerImageView;
@property (nonatomic, strong) UILabel *noShowLabel;
@end

@implementation AEHomeNoticeIconView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self imageView];
        [self noShowLabel];
        
    }
    return self;
}

- (void)updateNoShowNumber:(int)noShowNumber{
    if (noShowNumber <= 0) {
        self.noShowLabel.hidden = YES;
        return;
    }
    self.noShowLabel.hidden = NO;
    self.noShowLabel.text = [NSString stringWithFormat:@"%d",noShowNumber > 99 ? 99 : noShowNumber];
}

-(UIImageView *)imageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navtaion_top_notice"]];
        [self addSubview:_centerImageView];
        
        [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.equalTo(self.mas_right);
        }];
    }
    return _centerImageView;
}
- (UILabel *)noShowLabel {
    if (!_noShowLabel) {
        _noShowLabel = [AEBase createLabel:CGRectZero font:[UIFont systemFontOfSize:12] text:@"99" defaultSizeTxt:@"" color:[UIColor whiteColor] backgroundColor:AEThemeColor alignment:NSTextAlignmentCenter];
        _noShowLabel.clipsToBounds = YES;
        _noShowLabel.layer.cornerRadius = 7.5f;
        [self addSubview:_noShowLabel];
        
        [_noShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(15);
            make.right.equalTo(_centerImageView.mas_right).offset(7);
            make.top.equalTo(_centerImageView.mas_top).offset(-7);
        }];
    }
    return _noShowLabel;
}


@end
