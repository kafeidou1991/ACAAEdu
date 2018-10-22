//
//  HMBannerView.m
//  wyzc
//
//  Created by WyzcWin on 16/10/9.
//  Copyright © 2016年 北京我赢科技有限公司. All rights reserved.
//

#import "HMBannerView.h"
#import "UIImageView+WebCache.h"

@interface HMBannerView()<CAAnimationDelegate>{
    
    NSArray     *_imageArr;     // 图片数组
    UIImage     *_defaultImage; // 默认图片
    CGFloat      _timeInterval; // 定时器时间间隔
    NSString    *_animationType;// 动画方式
    
    NSTimer     *_timer;        // 定时器
    NSInteger    _currentIndex; // 当前Banner索引
    NSInteger    _totalNumber;  // 总页数
    
}

@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) UIPageControl     *pageControl;

@end

@implementation HMBannerView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray scrollTime:(CGFloat)time animationType:(NSString *)type{
    
    if (self = [super initWithFrame:frame]) {
        
        _imageArr       = imageArray;
        _timeInterval   = time;
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
     
        _totalNumber    = 0;
        _currentIndex   = 0;
        
        [self addSubview:self.imageView];
        
        [self addGestureRecognizer];
    }
    
    return self;
}
//为了适配在nib上显示
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _totalNumber    = 0;
        _currentIndex   = 0;
        
        [self addSubview:self.imageView];
        
        [self addGestureRecognizer];
    }
    return self;
}



- (void)updateBannerInfo:(NSArray *)imageArray timeInterval:(CGFloat)timeInterval defaultImg:(UIImage *)defaultImg styleType:(BannerStyle)styleType{
    
    _imageArr = imageArray;
    _totalNumber  = imageArray.count;
    _timeInterval = timeInterval;
    _defaultImage = defaultImg;
    
    if (styleType == BannerStyleHorizonPush) {
        _animationType = kCATransitionPush;
    }else if (styleType == BannerStyleFadeIn) {
        _animationType = kCATransitionMoveIn;
    }else if (styleType == BannerStyleCube) {
        _animationType = @"cube";
    }
    
    if (_pageControl && [self.subviews containsObject:_pageControl]) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    [self addSubview:self.pageControl];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:_currentIndex]] placeholderImage:[UIImage imageNamed:@"course_def_h"]];
    
    [self setupTimer];
}

- (void)addGestureRecognizer{
    
    UISwipeGestureRecognizer *gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    gestureLeft.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imageView addGestureRecognizer:gestureLeft];
    
    UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    gestureRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:gestureRight];
    
    UITapGestureRecognizer *gestureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerClick:)];
    gestureTap.numberOfTouchesRequired = 1;
    gestureTap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:gestureTap];
}

- (void)handleSwipeFromLeft:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    _currentIndex = _currentIndex - 1;
    if (_currentIndex < 0) {
        _currentIndex = _imageArr.count - 1;
    }
    self.pageControl.currentPage = _currentIndex;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[_currentIndex]] placeholderImage:[UIImage imageNamed:@"course_def_h"]];
    [self transTionWithsubtype:kCATransitionFromLeft];
}

- (void)handleSwipeFromRight:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    _currentIndex = _currentIndex + 1;
    if (_currentIndex >= _imageArr.count) {
        _currentIndex = 0;
    }
    self.pageControl.currentPage = _currentIndex;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[_currentIndex]] placeholderImage:[UIImage imageNamed:@"course_def_h"]];
    [self transTionWithsubtype:kCATransitionFromRight];
}

- (void)bannerClick:(UITapGestureRecognizer *)gestureRecognizer{
    
    if ([self.delegate respondsToSelector:@selector(bannerClickWithIndex:)]) {
        [self.delegate bannerClickWithIndex:_currentIndex];
    }
}

- (void)transTionWithsubtype:(NSString *)subtype{
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        
        [self setupTimer];
    }
    
    CATransition *transition = [CATransition new];
    transition.type = _animationType;
    transition.subtype = subtype;
    transition.duration = 0.5f;
    transition.delegate = self;
    [self.imageView.layer addAnimation:transition forKey:nil];
}

#pragma mark - UI 懒加载
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
    }
    
    return _imageView;
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        
        CGSize pageSize = [_pageControl sizeForNumberOfPages:_totalNumber];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, pageSize.width, pageSize.height)];
        _pageControl.numberOfPages = _totalNumber;
        _pageControl.center = CGPointMake(self.centerX, self.height - 8);
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = UIColorFromRGB(0xFBAB4E);//[UIColor grayColor];
    }
    
    return _pageControl;
}

- (void)setupTimer{
    
    if (_timer == nil) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(handleSwipeFromRight:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}
@end
