//
//  AEQuestionHeaderVIew.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/2.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEQuestionHeaderVIew.h"
#import "XHImageViewer.h"

@interface AEQuestionHeaderVIew ()

@property (nonatomic, strong) UIImageView * imageV;

@end


@implementation AEQuestionHeaderVIew
@synthesize imageV;

- (void)setQuestionData:(NSArray *)questionData {
    _questionData = questionData;
    [self removeAllSubviews];
    CGFloat leftMargin = 8.f;
    CGFloat viewHeight = leftMargin;
    for (AEQuestionSubItem * item in questionData) {
        if ([item.type isEqualToString:@"text"]) {
            UILabel * label = [AEBase createLabel:CGRectMake(leftMargin, viewHeight, self.width - 2 * leftMargin, 0) font:[UIFont systemFontOfSize:15] text:item.content defaultSizeTxt:nil color:AEColorLightText backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
            label.numberOfLines = 0;
            [label sizeToFit];
            viewHeight += label.height;
            [self addSubview:label];
        }else if ([item.type isEqualToString:@"img"]) {
            imageV = [[UIImageView alloc]init];
            imageV.userInteractionEnabled = YES;
            if (item.image) {
                CGFloat w = MIN(self.width - 2 * leftMargin, item.image.size.width);
                imageV.frame = CGRectMake((self.width - w )/2 , viewHeight, w, item.image.size.height);
            }else {
                imageV.frame = CGRectMake(leftMargin, viewHeight, self.width - 2 * leftMargin, (self.width - 2 * leftMargin) * 9 / 16);
            }
            imageV.contentMode = UIViewContentModeScaleAspectFit;
            if (!item.image) {
                [imageV sd_setImageWithURL:[NSURL URLWithString:item.content]completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                }];
            }else {
                imageV.image = item.image;
            }
            viewHeight += imageV.size.height;
            [self addSubview:imageV];
            
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        
            [imageV addGestureRecognizer:gesture];
            
        }
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewHeight + leftMargin);
    
}
- (void)tapHandle:(UITapGestureRecognizer *)tap  {
    
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    
    [imageViewer showWithImageViews:@[imageV] selectedView:(UIImageView *)tap.view];
}





@end
