//
//  AEBaseWebVC.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEBaseController.h"

@interface AEBaseWebVC : AEBaseController<WKNavigationDelegate,WKUIDelegate>
/**
 加载的webView
 */
@property (nonatomic, strong) WKWebView * webView;

/**
 链接桥
 */
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
/**
 是否显示左上角返回,默认显示
 */
@property (nonatomic, assign) BOOL isHiddenLeft;
/**
 加载的URL
 */
@property (nonatomic, copy)NSString * urlString;

/**
 是否隐藏了下面tabbar的高度，决定了 webView的高度 是否展示下部tabbar
 */
@property (nonatomic, assign) BOOL isHiddenBottom;

/**
 是否禁止长按 复制等操作  默认是禁止
 */
@property (nonatomic, assign) BOOL longPressGestureEnabled;

/**
 是否监听H5的title 默认是禁止
 */
@property (nonatomic, assign) BOOL isAllowTitle;

/**
 !!! 与H5交互接口  交互写在此方法里
 */
- (void)observeH5BridgeHandler;
/**
 加载本地html
 
 @param fileName 文件名称
 */
- (void)loadLocalHTMLString:(NSString *)fileName;


#pragma mark - common Method
/**
 获取当前用户的token值 用于登录时候给H5传递
 
 @return token
 */
- (NSString *)getCookieValue;

@end
