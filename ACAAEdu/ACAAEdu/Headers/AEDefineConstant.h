//
//  AEDefineConstant.h
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/1/24.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#ifndef AEDefineConstant_h
#define AEDefineConstant_h

// MARK:  -----NSLog-----
#if DEBUG
#define NSLog(s,...) NSLog(@"%s LINE:%d < %@ >",__FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define NSLog(...) {}
#endif


// MARK: -----字符串相关-----
/**
 *  格式化字符串
 *
 *  如果字符串为@"<null>" 或 NSNull类型 或者nil，会返回 @""
 */
#define stringFormat(string) (string == nil)?@"":[@"<null>" isEqualToString:[NSString stringWithFormat:@"%@",string]]?@"":[NSString stringWithFormat:@"%@",string]

#define STR_FONT_SIZE(str,maxWidth,font) [str boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size


/// 非空判断
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || [(_ref) isEqual:@"(null)"])
//字符串是否为空
#define STRISEMPTY(str) (str==nil || [str isEqual:[NSNull null]] || [str isEqualToString:@""])

// MARK: -----颜色相关-----
#define COLOR_RGB(r,g,b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1]
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]
#define AEHexColor(colorString) [UIColor colorWithHex:colorString]
#define AEHexColorAlpha(colorString,a) [UIColor colorWithHex:colorString alpha:a]

// MARK: -----简易使用-----
// 1.block的安全使用
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
// 2.weakSelf
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
// 3.非空判断
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || [(_ref) isEqual:@"(null)"])
// 4.把接收到的服务器数据安全转化为字符串
#define AEStringFormat(_ref) IsNilOrNull(_ref) ? @"--" : [NSString stringWithFormat:@"%@", _ref]
// 5.NSUserDefaults
#define AEUserDefaults [NSUserDefaults standardUserDefaults]
//User
#define User  [AEUserInfo shareInstance]
// 6.版本号
#define AEVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AEAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// MARK: -----屏幕尺寸相关-----
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define NAVIGATION_HEIGHT (IS_IPHONEX ? 88 : 64)
#define TAB_BAR_HEIGHT 49
#define STATUS_BAR_HEIGHT (IS_IPHONEX ? 44 : 20)
// home indicator
#define HOME_INDICATOR_HEIGHT (IS_IPHONEX ? 34.f : 0.f)

// MARK: -----设备相关-----
#define IS_IPHONE4 [[UIScreen mainScreen] bounds].size.height == 480.0
#define IS_IPHONE5 [[UIScreen mainScreen] bounds].size.height == 568.0
#define IS_IPHONE6 [[UIScreen mainScreen] bounds].size.height == 667.0
#define IS_IPHONE6PLUS [[UIScreen mainScreen] bounds].size.height == 736.0
#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)

// MARK: -----按屏幕大小缩放-----
#define MAIN_SCALE (IS_IPHONE5?0.9:(IS_IPHONE6?1:1.1))
#define SPECIAL_SCALE (IS_IPHONE5?0.8:(IS_IPHONE6?1:1.1))

// MARK: -----字体相关-----
#define UIFontLightOfSize(fontSize) (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2) ? [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight] : [UIFont systemFontOfSize:fontSize])
#define AECustomFont  @"PingFangSC-Regular"

// MARK: -----颜色相关-----
#define AEThemeColor      AEHexColor(@"#F55F62")   ///< 项目红
#define AEColorLightText  AEHexColor(@"#494949")   ///< 字体颜色  偏黑
#define AEColorLine       AEHexColor(@"#E5E5E5")   ///< 分割线颜色
#define AEColorBgVC       AEHexColor(@"#f0f2f6")   ///< 控制器背景颜色F5F5F5
#define AEFontColor       AEHexColor(@"#C88417") ///< 字体颜色

// MARK: -----系统相关-----
#define IS_IOS_7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)
#define IS_IOS_8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)
#define IS_IOS_9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? YES : NO)
#define IS_IOS_10 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) ? YES : NO)
#define IS_IOS_11 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) ? YES : NO)

// MARK: -----客服-----
#define ServicePhone @"4009650866"



#endif /* AEDefineConstant_h */
