//
//  HomeHeaderReusableView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "HomeHeaderReusableView.h"
#import "HMBannerView.h"

@interface HomeHeaderReusableView()<HMBannerViewClickDelegate>

@property (weak, nonatomic) IBOutlet HMBannerView *bannerView;

@end

@implementation HomeHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bannerView.delegate =self;
    
}

#pragma mark - banner点击
-(void)updateBanner:(NSArray *)array {
    [self.bannerView updateBannerInfo:array timeInterval:3.0f defaultImg:[UIImage imageNamed:@"banner_default"] styleType:BannerStyleHorizonPush];
}
- (void)bannerClickWithIndex:(NSInteger)index{
    NSLog(@"12312312");
}



@end
