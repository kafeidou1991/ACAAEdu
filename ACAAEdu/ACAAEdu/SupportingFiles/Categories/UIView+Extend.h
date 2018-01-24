//
//  UIView+Extend.h
//  library
//
//  Created by Shingo on 13-8-2.
//  Copyright (c) 2013年 Shingo. All rights reserved.
//


@interface UIView(Extend)

- (UIViewController *)viewController;

+ (UIView *)viewWithName:(NSString *)name;
- (void)clearBorderStyle;
- (void)searchContainerStyle;
- (void)borderStyleWithColor:(UIColor *)color;
- (void)cornerRadiusStyle;
- (void)cornerRadiusStyleWithValue:(CGFloat)value;
- (void)roundStyle;
- (void)roundHeightStyle;
- (UIColor *)colorAtPosition:(CGPoint)position;
- (CGSize)fitSize;
- (UIImage *)screenshot;
@end
