//
//  HomePageVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "HomePageVC.h"
#import "HomeCollectionView.h"
@interface HomePageVC ()
@property (nonatomic, strong) HomeCollectionView * mainCollectionView;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubViews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString * url =@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517936621904&di=59ff6ebac7e3d599f62849da4ba7a168&imgtype=jpg&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170626%2Fe27d47199ce645999100af5c0fc56f56_th.jpg";
        NSString * url1 =@"https://www.baidu.com/img/bd_logo1.png";
        NSString * url2 =@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517936621904&di=59ff6ebac7e3d599f62849da4ba7a168&imgtype=jpg&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170626%2Fe27d47199ce645999100af5c0fc56f56_th.jpg";
        NSArray * array = @[url,url1,url2];
        [self.mainCollectionView updateBanner:array];
    });
}

-(void)afterProFun {

}

- (void)addSubViews {

    [self.view addSubview:self.mainCollectionView];
}


#pragma mark - UI懒加载
-(HomeCollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        _mainCollectionView = [[HomeCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - NAVIGATION_HEIGHT - 49)];
        
    }
    return _mainCollectionView;
}


@end
