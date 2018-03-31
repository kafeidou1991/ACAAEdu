//
//  AnswerCardReusableView.m
//  wyzc
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 北京我赢科技有限公司. All rights reserved.
//   答题卡头视图

#import "AnswerCardReusableView.h"
@implementation AnswerCardReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        view.backgroundColor = AEColorLine;
        [self addSubview:view];
        
        UIImage *tagImage = [[UIImage imageNamed:@"TemplateTag"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, tagImage.size.width, tagImage.size.height)];
        _tagImageView.tintColor = AEThemeColor;
        _tagImageView.image = tagImage;
        [self addSubview:_tagImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tagImageView.frame) + 5, CGRectGetMinY(_tagImageView.frame), frame.size.width - CGRectGetMaxX(_tagImageView.frame) - 5, frame.size.height-14)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setLabelText:(NSString *)text
{
   
    self.titleLabel.text = text;
    [self.titleLabel sizeToFit];
}

@end

@implementation StatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
    _imageView.frame = CGRectMake(0, (self.height - 13.0f)/2, 13.0f, 13.0f);
    _titleLabel.frame = CGRectMake(_imageView.right, 0, self.width - _imageView.width, self.height);
}

@end

@implementation AnswerCardStatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *btnTitels = @[@"未答",@"完成",@"标记"];
        NSArray *btnImages = @[[UIImage imageNamed:@"TestStatusNo"],[UIImage imageNamed:@"TestStatusFinished"],[UIImage imageNamed:@"TestStatusTag"]];
        NSArray *btnTitleColor = @[UIColorFromRGB(0x969696),UIColorFromRGB(0x5BAEF5),UIColorFromRGB(0xFF7573)];
        CGFloat viewWidth = 50.0f, viewHeight = 15.0f;
        for (int i=0; i<btnTitels.count; i++) {
            StatusView *statusView = [[StatusView alloc] initWithFrame:CGRectMake(self.width - (viewWidth+5.0f)*(btnTitels.count - i), self.height - viewHeight, viewWidth, viewHeight)];
            [statusView setImage:btnImages[i]];
            statusView.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            statusView.titleLabel.textColor = btnTitleColor[i];
            statusView.titleLabel.text = btnTitels[i];
            [self addSubview:statusView];
        }
    }
    return self;
}

@end

@implementation TestPaperTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *btnTitels = @[@"未答",@"完成",@"标记"];
        NSArray *btnImages = @[[UIImage imageNamed:@"TestStatusNo"],[UIImage imageNamed:@"TestStatusFinished"],[UIImage imageNamed:@"TestStatusTag"]];
        NSArray *btnTitleColor = @[UIColorFromRGB(0x969696),UIColorFromRGB(0x5BAEF5),UIColorFromRGB(0xFDB901)];
        CGFloat viewWidth = 50.0f, viewHeight = 15.0f;
        for (int i=0; i<btnTitels.count; i++) {
            StatusView *statusView = [[StatusView alloc] initWithFrame:CGRectMake(self.width - (viewWidth+5.0f)*(btnTitels.count - i), (self.height - viewHeight)/2, viewWidth, viewHeight)];
            [statusView setImage:btnImages[i]];
            statusView.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            statusView.titleLabel.textColor = btnTitleColor[i];
            statusView.titleLabel.text = btnTitels[i];
            [self addSubview:statusView];
        }
    }
    return self;
}

@end
