//
//  UIView+DrawLine.m
//  BlueMobiProject
//
//  Created by iOS developer on 15/9/29.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//

#import "UIView+DrawLine.h"

@implementation UIView (DrawLine)

+ (UIView *)viewLinePoint:(CGPoint)point
                   inView:(UIView *)pview
                   length:(CGFloat)length
                 andAngle:(float)angle
                lineColor:(UIColor *)lineColor
                lineWidth:(float)lineWidth
{
    if (length == 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(point.x-length*.5, point.y-.5, length, lineWidth/scale)];
    [pview addSubview:line];
    
    if (lineColor) {
        line.backgroundColor = lineColor;
    } else {
        line.backgroundColor = BACKCOLOR(@"333333");
    }
    
    line.layer.anchorPoint = CGPointMake(0, 0);
    line.transform         = CGAffineTransformIdentity;
    line.transform         = CGAffineTransformMakeRotation(angle);
    [pview bringSubviewToFront:line];
    
    return line;
}
@end
