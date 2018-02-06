//
//  AEBaseTableController.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"

@interface AEBaseTableController : AEBaseController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) NSInteger currPage;

/** tableview */
@property (nonatomic, strong) UITableView * tableView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSources;

/**
 创建tableView
 */
- (void)createTableViewStyle:(UITableViewStyle)style;

#pragma mark - 刷新相关
/**
 增加头部刷新
 @param isRightNow 是否进入页面自动刷新，不用下拉
 @param block 刷新回调 处理完业务逻辑之后记得调用 [weakSelf endRefesh:YES]来结束刷新
 */
- (void)addHeaderRefesh:(BOOL)isRightNow Block:(MJRefreshComponentRefreshingBlock)block;
/**
 设置底部加载
 @param block block 刷新回调 处理完业务逻辑之后记得调用 [weakSelf endRefesh:NO]来结束刷新
 */
- (void)addFooterRefesh:(MJRefreshComponentRefreshingBlock)block;
/**
 结束刷新
 
 @param isHeader 标记下拉刷新还是上拉加载
 */
- (void)endRefesh:(BOOL)isHeader;
/**
 上拉加载 已经没有数据样式
 */
- (void)noHasMoreData;

@end
