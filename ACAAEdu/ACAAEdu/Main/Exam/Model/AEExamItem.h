//
//  AEExamItem.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/7.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "DateCenter.h"
//考试列表页
@interface AEExamItem : DateCenter
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * subject_price;
@property (nonatomic, copy) NSString * version;
@property (nonatomic, copy) NSString * subject_full_name;
@property (nonatomic, copy) NSString * delete_time;
@property (nonatomic, copy) NSString * short_name;
@property (nonatomic, copy) NSString * subject_type;
@property (nonatomic, copy) NSString * subject_type_name;
@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * is_actived;
@property (nonatomic, copy) NSString * subject_name;
@property (nonatomic, copy) NSString * create_time;

//本地多选使用
@property (nonatomic, assign) BOOL isSelect;

@end
//我的模考数据
@interface AEExamSubjectItem :DateCenter
@property (nonatomic, copy) NSString * is_actived;
@property (nonatomic, copy) NSString * subject_type_name;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * subject_type;
@property (nonatomic, copy) NSString * subject_name;
@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * version;
@property (nonatomic, copy) NSString * short_name;
@property (nonatomic, copy) NSString * subject_price;
@property (nonatomic, copy) NSString * subject_full_name;

@end
//我的模考数据
@interface AEMyExamItem :DateCenter


@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, strong) AEExamSubjectItem * subject;
@property (nonatomic, copy) NSString * user_id;
@property (nonatomic, copy) NSString * subject_id;


@end
