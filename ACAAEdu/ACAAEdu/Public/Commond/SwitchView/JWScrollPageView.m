//
//  JWScrollPageView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "JWScrollPageView.h"

@interface JWScrollPageView ()<UIScrollViewDelegate>{
    NSInteger mCurrentPage;
    BOOL mNeedUseDelegate;
}

@end

@implementation JWScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mNeedUseDelegate = YES;
        [self commInit];
    }
    return self;
}

-(void)initData{
    [self freshContentTableAtIndex:0];
}


-(void)commInit{
    if (_contentItems == nil) {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    [self addSubview:_scrollView];
}

-(void)dealloc{
    [_contentItems removeAllObjects];
}

#pragma mark - 其他辅助功能
#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSInteger)aNumerOfTables{
    
}

#pragma mark 移动ScrollView到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex{
    mNeedUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.width);
    [_scrollView scrollRectToVisible:vMoveRect animated:NO];
    mCurrentPage= aIndex;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

#pragma mark 刷新某个页面
-(void)freshContentTableAtIndex:(NSInteger)aIndex{
    if (_contentItems.count < aIndex) {
        return;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    mNeedUseDelegate = YES;
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    if ([_delegate respondsToSelector:@selector(scrollViewWillBeginPage:)]) {
        [_delegate scrollViewWillBeginPage:page];
    }
}
#define SCreenWidth      (([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height)?([UIScreen mainScreen].bounds.size.height):([UIScreen mainScreen].bounds.size.width))
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (_scrollView.contentOffset.x+SCreenWidth/2.0) / SCreenWidth;
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage= page;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        //        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        //        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        //        [self moveToTargetPosition:targetX];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

#pragma mark - ToJsonString
/**
 *  转换NSArray和NSDictionary为json格式
 *
 *  @param object NSArray和NSDictionary
 *
 *  @return NSString
 */
- (NSString *)dataToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"Get an error: %@",error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}



@end
