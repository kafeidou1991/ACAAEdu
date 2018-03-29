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
#import "AEExamContentView.h"

#define MENUHEIHT 41

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
    [self createScrollerMenuView];
}
//MARK: 请求数据
-(void)afterProFun {
    WS(weakSelf)
    [self startExamPaper:^(AEStartExamItem * item) {
        [weakSelf getPartExamPaper:item];
    }];
}
//开始考试
- (void)startExamPaper:(void(^)(AEStartExamItem *))success {
    WS(weakSelf);
    [self hudShow:self.view msg:STTR_ater_on];
//    137 138 self.examItem.id
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kStartExamPaper query:nil path:nil body:@{@"subject_id":@"138"} success:^(id object) {
        AEStartExamItem * item = [AEStartExamItem yy_modelWithJSON:object];
        if (success) {
            success(item);
        }
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}
//获取部分考试题型
- (void)getPartExamPaper:(AEStartExamItem *)item{
    WS(weakSelf);
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypeGET methodName:kPartExamPaper query:@{@"user_exam_id":item.id}.mutableCopy path:nil body:nil success:^(id object) {
        [weakSelf hudclose];
//        AEStartExamItem * item = [AEStartExamItem yy_modelWithJSON:object];
       
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf hudclose];
        [AEBase alertMessage:error cb:nil];
    }];
}


//MARK: MenuHrizontalDelegate
- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex
{
    [_scrollPageView moveScrollowViewAthIndex:aIndex];
}
-(void)didScrollPageViewChangedPage:(NSInteger)aPage {
    [_menuBarView changeMenuStateAtIndex:aPage];
    
    [_scrollPageView freshContentTableAtIndex:aPage];
}
-(void)scrollViewWillBeginPage:(NSInteger)aPage {
    
}
//MARK: initUI
- (void)createScrollerMenuView {
    //默认选中第一个button
    [self.view addSubview:self.menuBarView]; //题型选择按钮
    [self.menuBarView clickMenuAtIndex:0];
    [self.view addSubview:self.scrollPageView];
}

- (void)setContentTableViews {
    _scrollPageView.scrollView.showsHorizontalScrollIndicator = YES;
    
    UICollectionViewFlowLayout * vlf = [[UICollectionViewFlowLayout alloc]init];
    vlf.minimumLineSpacing = 0;
    vlf.minimumInteritemSpacing = 0;
    vlf.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    vlf.itemSize = CGSizeMake(_scrollPageView.width, _scrollPageView.height);
    vlf.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    for (NSInteger i = 0 ; i<self.dataSourceArr.count; i++) {
        AEExamContentView * view = [[AEExamContentView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i,0, _scrollPageView.width, _scrollPageView.frame.size.height) collectionViewLayout:vlf];
        
        [_scrollPageView.scrollView addSubview:view];
        [_scrollPageView.contentItems addObject:view];
        
    }
    [_scrollPageView.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * self.dataSourceArr.count, _scrollPageView.frame.size.height)];
}
- (NSArray *)loadExamData {
    self.dataSourceArr = @[@{@"type":@"单选题"},@{@"type":@"多选题"},@{@"type":@"判断题"}];
    //组装数据（后期再进行优化）
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in self.dataSourceArr) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setValue:@"normal.png" forKey:NOMALKEY];
        [dict setValue:@"helight.png" forKey:HEIGHTKEY];
        [dict setValue:dic[@"type"] forKey:TITLEKEY];
//        [dict setValue:[NSNumber numberWithFloat:[dic[@"type"] boundingRectWithSize:CGSizeMake(MAXFLOAT, 30.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size.width+20] forKey:TITLEWIDTH];
        //三等分
        [dict setValue:[NSNumber numberWithFloat:SCREEN_WIDTH/self.dataSourceArr.count] forKey:TITLEWIDTH];
        [buttonArray addObject:dict];
    }
    return buttonArray.copy;
}
-(JWMenuBarView *)menuBarView {
    if (!_menuBarView) {
        _menuBarView = [[JWMenuBarView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, MENUHEIHT) titles:[self loadExamData]];
        _menuBarView.delegate = self;
    }
    return _menuBarView;
}
-(JWScrollPageView *)scrollPageView {
    if (!_scrollPageView) {
        _scrollPageView = [[JWScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT - MENUHEIHT)];
        _scrollPageView.delegate = self;
        //添加数据
        [self setContentTableViews];
    }
    return _scrollPageView;
}


@end
