//
//  UIImage+help.m
//  IHaoMu
//
//  Created by  wuhiwi on 16/11/2.
//  Copyright © 2016年 ihaomu.com. All rights reserved.
//

#import "UIImage+help.h"

@implementation UIImage (help)

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    
    return smallImage;
}
//等比例缩放UIImage
+ (UIImage*)scaleImage:(UIImage*)img toSize:(CGSize)size
{
    int h = img.size.height;
    int w = img.size.width;
    
    if(h <= size.height && w <= size.width) {
        return img;
    } else {
        float destWith = 0.0f;
        float destHeight = 0.0f;
        
        float suoFang = (float)w/h;
        float suo = (float)h/w;
        if (w>h) {
            destWith = (float)size.width;
            destHeight = size.width * suo;
        }else {
            destHeight = (float)size.height;
            destWith = size.height * suoFang;
        }
        CGSize itemSize = CGSizeMake(destWith, destHeight);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0, 0, destWith, destHeight);
        [img drawInRect:imageRect];
        UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImg;
    }
}

/**
 *  根据颜色生成纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *   图片和颜色混合处理，返回图片
 *
 */
+ (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    @autoreleasepool {
        // No-op if the orientation is already correct
        if (aImage.imageOrientation == UIImageOrientationUp)
            return aImage;
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (aImage.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
            default:
                break;
        }
        
        switch (aImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            default:
                break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                                 CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                                 CGImageGetColorSpace(aImage.CGImage),
                                                 CGImageGetBitmapInfo(aImage.CGImage));
        CGContextConcatCTM(ctx, transform);
        switch (aImage.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                // Grr...
                CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
                break;
                
            default:
                CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
                break;
        }
        
        // And now we just create a new UIImage from the drawing context
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        UIImage *img = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
        return img;
    }
}

//缩放图片
+ (UIImage *)scaleImage:(UIImage *)oriImage size:(CGSize)newsize {
    UIGraphicsBeginImageContext(newsize);
    [oriImage drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//压缩图片 quality 0.5-0.6
+ (NSData*)compressImage:(UIImage *)oriImage quality:(float)quality {
    NSData *new_data = UIImageJPEGRepresentation(oriImage,quality);
    return new_data;
}
// 圆角图片
+ (UIImage *)wl_drawRoundImage:(UIImage *)image andSize:(CGSize)size {
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    // 设置剪裁区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    [path addClip];
    // 绘制图片到图形上下文
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从图形上下文中获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)garyImage {
    int bitmapInfo = kCGImageAlphaNone;
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef image = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    CGContextRelease(context);
    return grayImage;
}
@end
