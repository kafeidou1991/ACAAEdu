//
//  AnswerCardReusableView.h
//  wyzc
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 北京我赢科技有限公司. All rights reserved.
//  答题卡头视图

#import <UIKit/UIKit.h>

@interface AnswerCardReusableView : UICollectionReusableView

@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setLabelText:(NSString *)text;


@end

@interface StatusView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setImage:(UIImage *)image;

@end

@interface AnswerCardStatusView : UICollectionReusableView


@end

@interface TestPaperTagView : UIView

@end

