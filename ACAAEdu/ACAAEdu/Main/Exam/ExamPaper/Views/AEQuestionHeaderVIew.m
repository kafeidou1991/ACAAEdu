//
//  AEQuestionHeaderVIew.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/2.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEQuestionHeaderVIew.h"

@interface AEQuestionHeaderVIew ()

@end


@implementation AEQuestionHeaderVIew

-(void)setQuestionData:(NSArray *)questionData {
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
//            (self.width - 2 * leftMargin) * 9 / 16
            UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(leftMargin, viewHeight, self.width - 2 * leftMargin, 0)];
//            imageV.backgroundColor = [UIColor redColor];
            imageV.contentMode = UIViewContentModeScaleAspectFit;
            [imageV sd_setImageWithURL:[NSURL URLWithString:item.content]completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                imageV.size = image.size;
            }];
            [self addSubview:imageV];
        }
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewHeight + 2 * leftMargin);
    
    
    
}





@end
