//
//  AEAnswerCardView.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/4/1.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSIndexPath * indexPath);

@interface AEAnswerCardView : UICollectionView


@property (nonatomic, copy) NSMutableArray * paperData;

@property (nonatomic, copy) SelectBlock selectblock;

@end
