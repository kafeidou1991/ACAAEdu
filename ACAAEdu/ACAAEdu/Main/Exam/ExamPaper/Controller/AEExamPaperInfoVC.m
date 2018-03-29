//
//  AEExamPaperInfoVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamPaperInfoVC.h"
#import "AEExamItem.h"
#import "JWMenuBarView.h"
#import "JWScrollPageView.h"

@interface AEExamPaperInfoVC ()<MenuBarViewDelegate,ScrollPageViewDelegate>
/**
 题型数组
 */
@property (nonatomic, copy) NSArray *dataSourceArr;
/**
 菜单栏
 */
@property (nonatomic, strong) JWMenuBarView * menuBarView;
/**
 滚动区域视图
 */
@property (nonatomic, strong) JWScrollPageView * scrollPageView;

@end

@implementation AEExamPaperInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.examItem.subject_full_name;//@"试卷信息";
    self.dataSourceArr = @[@{@"type":@"单选题"},@{@"type":@"多选题"},@{@"type":@"判断题"}];
    [self createScrollerMenuView];
}
-(void)afterProFun {
//    WS(weakSelf);
//    [self hudShow:self.view msg:STTR_ater_on];
//    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kStartExamPaper query:nil path:nil body:@{@"subject_id":self.examItem.id} success:^(id object) {
//        [weakSelf hudclose];
//        AEStartExamItem * item = [AEStartExamItem yy_modelWithJSON:object];
//
//    } faile:^(NSInteger code, NSString *error) {
//        [weakSelf hudclose];
//        [AEBase alertMessage:error cb:nil];
//    }];
}

- (void)createScrollerMenuView {
//    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:0];
//    for (NSDictionary *dic in self.dataSourceArr) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
//        [dict setValue:@"normal.png" forKey:NOMALKEY];
//        [dict setValue:@"helight.png" forKey:HEIGHTKEY];
//        [dict setValue:dic[@"type"] forKey:TITLEKEY];
//        [dict setValue:[NSNumber numberWithFloat:[dic[@"type"] boundingRectWithSize:CGSizeMake(MAXFLOAT, 30.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size.width+20] forKey:TITLEWIDTH];
//        [buttonArray addObject:dict];
//    }
//
//    if (self.menuBarView == nil) {
//        self.menuBarView = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 100, SCreenWidth, MENUHEIHT) ButtonItems:buttonArray];
//        self.mMenuHriZontal.delegate = self;
//
//        self.mMenuHriZontal.backgroundColor = [UIColor blueColor];//UIColorFromRGB(0xf5f8fe);
//    }
//    
//    if (mScrollPageView == nil) {
//        mScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT + 100, SCreenWidth, SCreenHegiht - 64 - MENUHEIHT - 100)];
//        mScrollPageView.delegate = self;
//        //添加数据
//        [self setContentTableViews];
//    }
//
//    //默认选中第一个button
//    [self.mMenuHriZontal clickButtonAtIndex:0];
//    [self.view addSubview:self.mMenuHriZontal]; //题型选择按钮
//    [self.view addSubview:mScrollPageView];
}

//MARK: menu


@end
