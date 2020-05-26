//
//  UIImage+WX.h
//  BlueMobiProject
//
//  Created by iOS developer on 15/9/17.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WX)

- (UIImage *)rounded;

- (UIImage *)rounded:(CGRect)circleRect;

- (UIImage *)stretched;

- (UIImage *) stretchWithRect:(CGRect)rect;

+ (UIImage *) createImageWithColor:(UIColor *)color withRect:(CGRect)rect;
@end
