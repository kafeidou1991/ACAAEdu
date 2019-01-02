//
//  AEExamTimeView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2019/1/2.
//  Copyright © 2019 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AEExamTimeView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *examNumLabel;

@end

NS_ASSUME_NONNULL_END
