//
//  DateCenter.m
//  YZF
//
//  Created by 张竟巍 on 2017/3/27.
//  Copyright © 2017年 Beijing Yi Cheng Agel Ecommerce Ltd. All rights reserved.
//

#import "DateCenter.h"

@implementation DateCenter
//+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
//    return @{@"userId":@"id"};
//}
@end



@implementation AEAppVersion

@end

@implementation AEUserProfile

@end

@implementation AEMyOrderList

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"goods":[AEGoodItem class]};
}

@end

@implementation AEGoodItem
@end

@implementation AEScreeningItem
@end

@implementation AEMessageList
@end

@implementation AEExamQuestionItem

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"question":[AEQuestionRresult class]};
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [self yy_modelCopy];
}


@end

@implementation AEQuestionRresult

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"result":[NSString class],@"question":[AEQuestionSubItem class]};
}

@end

@implementation AEQuestionSubItem

- (void)setContent:(NSString *)content {
    if ([content hasPrefix:@"http"]) {
        //图片链接内部有空格 用%20替换 否则无法显示出来
        _content = [content stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }else {
        _content = content;
    }
}

@end

@implementation AEResultItem

@end

@implementation AEExamEvaluateSubItem

@end
@implementation AEExamKnowPointItem

@end

@implementation AEExamEvaluateItem

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"part_info":[AEExamEvaluateSubItem class],@"category_info":[AEExamKnowPointItem class]};
}

@end

@implementation AEAcaaCategoryItem

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"subject":[AEExamItem class]};
}

@end


