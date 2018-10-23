//
//  AEBaseTopView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/10/23.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseTopView.h"

static const CGFloat SPACE_HEIGHT = 44.f;
static const CGFloat LEFT_TITLE_SPACE = 40.f;

@interface AEBaseTopView ()

@property (nonatomic, strong) UIView * spaceView; //展位图
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation AEBaseTopView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self spaceView];
        [self imageView];
        [self titleLabel];
        [self backBtn];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self spaceView];
        [self imageView];
        [self titleLabel];
        [self backBtn];
    }
    return self;
}

#pragma mark - setter getter
- (UIView *)spaceView {
    if (!_spaceView) {
        _spaceView = [[UIView alloc]init];
        _spaceView.backgroundColor = [UIColor clearColor];
        [self addSubview:_spaceView];
        [_spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(SPACE_HEIGHT);
        }];
    }
    return _spaceView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"ic_data_banner_b"];
        [self.spaceView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:25];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"关于我们";
        [self.spaceView addSubview:_titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(LEFT_TITLE_SPACE));
            make.centerY.equalTo(_spaceView);
        }];
    }
    return _titleLabel;
}
-(UIButton *)backBtn {
    if (!_backBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"left_back_arrow"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"left_back_arrow"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"left_back_arrow"] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = button;
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(STATUS_BAR_HEIGHT);
            make.left.mas_equalTo(5);
            make.width.height.mas_equalTo(40);
        }];
    }
    return _backBtn;
}
- (void)back {
    if (_backBlock) {
        _backBlock();
    }else {
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }
}


-(void)setTitleName:(NSString *)titleName{
    _titleName = titleName;
    self.titleLabel.text = titleName;
}
-(void)setImageViewName:(NSString *)imageViewName{
    _imageViewName = imageViewName;
    self.imageView.image = [UIImage imageNamed:imageViewName];
}


@end
