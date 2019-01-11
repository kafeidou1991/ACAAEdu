//
//  AEExamItem.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/7.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamItem.h"
#import "YYModel.h"

@implementation AEExamItem

//+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
//    return @{@"exam_id":@"id"};
//}


- (NSString *)getRealPrice {
    if (!STRISEMPTY(_subject_realPrice)) {
        return _subject_realPrice;
    }
    float price = self.subject_price.floatValue;
    float discountPrice = self.subject_discount.floatValue;
    float real = (price - discountPrice) > 0 ? (price - discountPrice) : 0.00;
    return [NSString stringWithFormat:@"%.2f",real];
}

@end

@implementation AEExamSubjectItem

@end
@implementation AEMyExamItem

@end

