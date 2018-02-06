//
//  HMBannerView.h
//  wyzc
//
//  Created by WyzcWin on 16/10/9.
//  Copyright © 2016年 北京我赢科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BannerStyle) {
    BannerStyleFadeIn,      // 深入浅出
    BannerStyleCube,        // 立方体
    BannerStyleHorizonPush, // 推
};

@protocol HMBannerViewClickDelegate <NSObject>
- (void)bannerClickWithIndex:(NSInteger)index;
@end


//  自定义Banner
@interface HMBannerView : UIView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray scrollTime:(CGFloat)time animationType:(NSString *)type;

- (void)updateBannerInfo:(NSArray *)imageArray timeInterval:(CGFloat)timeInterval defaultImg:(UIImage *)defaultImg styleType:(BannerStyle)styleType;

@property (nonatomic, weak) id<HMBannerViewClickDelegate> delegate;

@end
