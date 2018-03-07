//
//  AEExamItem.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/7.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "DateCenter.h"
@interface AEExamItem : DateCenter

@property (nonatomic, copy) NSString * client_topic;
@property (nonatomic, copy) NSString * create_time;
@property (nonatomic, copy) NSString * default_rule;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * is_actived;
@property (nonatomic, copy) NSString * is_client;
@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * logo_path;
@property (nonatomic, copy) NSString * make_cert;
@property (nonatomic, copy) NSString * short_name;
@property (nonatomic, copy) NSString * skip_exam;
@property (nonatomic, copy) NSString * subject_full_name;
@property (nonatomic, copy) NSString * subject_name;
@property (nonatomic, copy) NSString * update_time;
@property (nonatomic, copy) NSString * version;

@end
