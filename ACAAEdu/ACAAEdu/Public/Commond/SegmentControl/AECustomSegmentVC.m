//
//  AESegmentControl.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/26.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AECustomSegmentVC.h"
#import "SGPagingView.h"
#import "AEMessageListVC.h"

@interface AECustomSegmentVC ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@end

@implementation AECustomSegmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)setupPageView:(NSArray *)titlesArray ContentViewControllers:(NSArray <UIViewController *> * )viewControllers {
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 64;
    } else {
        pageTitleViewY = 88;
    }
    if(titlesArray.count == 0 || viewControllers.count == 0 || (titlesArray.count != viewControllers.count)) {
        return;
    }
    NSArray *titleArr = titlesArray;
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleColor = AEHexColor(@"333333");
    configure.titleSelectedColor = AEThemeColor;
    configure.indicatorColor = AEThemeColor;
    configure.indicatorAdditionalWidth = MAXFLOAT; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    configure.bottomSeparatorColor = AEColorLine;
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pageTitleView];
    //    _pageTitleView.selectedIndex = 1;
    NSArray *childArr = viewControllers;
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageContentViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}



@end
