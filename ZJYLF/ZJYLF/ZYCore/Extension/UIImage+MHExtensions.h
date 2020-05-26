//
//  UIImage+Extensions.h
//  PhotoFlair
//
//  Created by admin on 14-2-25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

CGFloat MHDegreesToRadians(CGFloat degrees);

CGFloat MHRadiansToDegrees(CGFloat radians);

@interface UIImage (MHExtensions)

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur;
- (UIImage *)imageWithShadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset
                       shadowBlur:(CGFloat)shadowBlur;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

//压缩图片到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)fixOrientation:(UIImage *)aImage;

@end;
