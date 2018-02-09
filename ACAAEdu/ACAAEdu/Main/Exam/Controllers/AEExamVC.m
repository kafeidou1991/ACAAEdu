//
//  AEExamVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/8.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEExamVC.h"
#import "ExameCollectionView.h"

@interface AEExamVC ()

@property (nonatomic, strong) ExameCollectionView * mainCollectionView;

@end

@implementation AEExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;

}
-(void)addSubViews {
    
    [self.view addSubview:self.mainCollectionView];
}

#pragma mark - UI懒加载
-(ExameCollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        _mainCollectionView = [[ExameCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - NAVIGATION_HEIGHT - 49)];
    }
    return _mainCollectionView;
}


@end
