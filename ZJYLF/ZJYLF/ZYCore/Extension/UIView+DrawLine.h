//
//  UIView+DrawLine.h
//  BlueMobiProject
//
//  Created by iOS developer on 15/9/29.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DrawLine)

+ (UIView *)viewLinePoint:(CGPoint)point
                   inView:(UIView *)pview
                   length:(CGFloat)length
                 andAngle:(float)angle
                lineColor:(UIColor *)lineColor
                lineWidth:(float)lineWidth;
@end
