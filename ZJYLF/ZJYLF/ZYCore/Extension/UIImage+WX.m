//
//  UIImage+WX.m
//  BlueMobiProject
//
//  Created by iOS developer on 15/9/17.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//

#import "UIImage+WX.h"

@implementation UIImage (WX)

- (UIImage *)rounded
{
    UIImage * image = self;
    if ( nil == image )
        return nil;
    
    CGSize imageSize = image.size;
    imageSize.width = floorf( imageSize.width );
    imageSize.height = floorf( imageSize.height );
    
    CGFloat imageWidth = fminf(imageSize.width, imageSize.height);
    CGFloat imageHeight = imageWidth;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate( NULL,
                                                 imageWidth,
                                                 imageHeight,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 imageWidth * 4,
                                                 colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedLast );
    
    CGContextBeginPath(context);
    CGRect circleRect;
    circleRect.origin.x = 0;
    circleRect.origin.y = 0;
    circleRect.size.width = imageWidth;
    circleRect.size.height = imageHeight;
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGRect drawRect;
    drawRect.origin.x = 0;
    drawRect.origin.y = 0;
    drawRect.size.width = imageWidth;
    drawRect.size.height = imageHeight;
    CGContextDrawImage(context, drawRect, image.CGImage);
    
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease( colorSpace );
    
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

- (UIImage *)rounded:(CGRect)circleRect
{
    UIImage * image = self;
    if ( nil == image )
        return nil;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate( NULL,
                                                 circleRect.size.width,
                                                 circleRect.size.height,
                                                 CGImageGetBitsPerComponent( image.CGImage ),
                                                 circleRect.size.width * 4,
                                                 colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedLast );
    
    CGContextBeginPath(context);
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGRect drawRect;
    drawRect.origin.x = 0; //(imageSize.width - imageWidth) / 2.0f;
    drawRect.origin.y = 0; //(imageSize.height - imageHeight) / 2.0f;
    drawRect.size.width = circleRect.size.width;
    drawRect.size.height = circleRect.size.height;
    CGContextDrawImage(context, drawRect, image.CGImage);
    
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context
{
    CGContextSaveGState( context );
    CGContextTranslateCTM( context, CGRectGetMinX(rect), CGRectGetMinY(rect) );
    CGContextSetShouldAntialias( context, true );
    CGContextSetAllowsAntialiasing( context, true );
    CGContextAddEllipseInRect( context, rect );
    CGContextClosePath( context );
    CGContextRestoreGState( context );
}

- (UIImage *) stretched
{
    CGFloat leftCap = floorf(self.size.width / 2.0f);
    CGFloat topCap = floorf(self.size.height / 2.0f);
    return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *) stretchWithRect:(CGRect)rect
{
    CGFloat leftCap = floorf(rect.size.width / 2.0f);
    CGFloat topCap = floorf(rect.size.height / 2.0f);
    return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

+ (UIImage *) createImageWithColor:(UIColor *)color withRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
