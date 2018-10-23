//
//  AEBaseTopView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/10/23.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseTopView.h"

@interface AEBaseTopView ()

@property (nonatomic, strong) UIView * spaceView; //展位图
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *leftimageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AEBaseTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self spaceView];
        [self imageView];
        [self leftimageView];
        [self titleLabel];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self spaceView];
        [self imageView];
        [self leftimageView];
        [self titleLabel];
    }
    return self;
}

- (UIView *)spaceView {
    if (!_spaceView) {
        _spaceView = [[UIView alloc]init];
        _spaceView.backgroundColor = [UIColor clearColor];
        [self addSubview:_spaceView];
        [_spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(44);
        }];
    }
    return _spaceView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
//        _imageView.image = [UIImage imageNamed:@"ic_data_banner_b"];
        [self.spaceView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
    }
    return _imageView;
}
-(UIImageView *)leftimageView {
    if (!_leftimageView) {
        _leftimageView = [[UIImageView alloc]init];
        
        _leftimageView.image = [UIImage imageNamed:@"navtaion_topstyle"];
        [self.spaceView addSubview:_leftimageView];
        [_leftimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.equalTo(_spaceView);
        }];
    }
    return _leftimageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.text = @"首页";
        [self.spaceView addSubview:_titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftimageView.mas_right).offset(10);
            make.centerY.equalTo(_spaceView);
        }];
    }
    return _titleLabel;
}


-(void)setTitleName:(NSString *)titleName{
    _titleName = titleName;
    self.titleLabel.text = titleName;
}
-(void)setImageViewName:(NSString *)imageViewName{
    _imageViewName = imageViewName;
    self.imageView.image = [UIImage imageNamed:imageViewName];
}
-(void)setLeftImageViewName:(NSString *)leftImageViewName {
    _leftImageViewName = leftImageViewName;
    self.leftimageView.image = [UIImage imageNamed:leftImageViewName];
}


@end
