
//
//  ArrowView.m
//  ZJYLF
//
//  Created by 刘高洋 on 2018/7/5.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import "ArrowView.h"

@implementation ArrowView

//绘制带箭头的矩形

-(void)drawArrowRectangle:(CGRect) frame

{
    
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    
    // 创建一个新的空图形路径。
    
    CGContextBeginPath(ctx);
    
    
    
    //启始位置坐标x，y
    
    CGFloat origin_x = frame.origin.x+7;
    
    CGFloat origin_y = frame.origin.y;
    
    //第一条线的位置坐标
    
    CGFloat line_1_x = frame.size.width+origin_x;
    
    CGFloat line_1_y = origin_y;
    
    //第二条线的位置坐标
    
    CGFloat line_2_x = line_1_x;
    
    CGFloat line_2_y = frame.size.height;
    
    //第三条线的位置坐标
    
    CGFloat line_3_x = origin_x;
    
    CGFloat line_3_y = line_2_y;
    
    //第四条线位置坐标
    
    CGFloat line_4_x = origin_x;
    
    CGFloat line_4_y = line_2_y - (frame.size.height -7)/2;
    
    //尖角的顶点位置坐标
    
    CGFloat line_5_x = origin_x - 7;
    
    CGFloat line_5_y = line_2_y - (frame.size.height -7)/2-3.5;
    
    //第六条线位置坐标
    
    CGFloat line_6_x = origin_x;
    
    CGFloat line_6_y = (frame.size.height -7)/2;
    
    
    
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    
    
    CGContextAddArc(ctx, 4 +origin_x, 4+origin_y, 4,1.5 *M_PI,M_PI,0);
    CGContextAddLineToPoint(ctx, line_1_x, line_1_y);
    
    CGContextAddLineToPoint(ctx, line_2_x, line_2_y);
    
    CGContextAddLineToPoint(ctx, line_3_x, line_3_y);
    
    
    
    CGContextAddLineToPoint(ctx, line_4_x, line_4_y);
    
    CGContextAddLineToPoint(ctx, line_5_x, line_5_y);
    
    CGContextAddLineToPoint(ctx, line_6_x, line_6_y);

    
    
    [SepartorLineColor setStroke];
    CGContextClosePath(ctx);
    
    CGContextStrokePath(ctx);
    
    
    
//    UIColor *costomColor = WhiteBackColor;
//
//    CGContextSetFillColorWithColor(ctx, costomColor.CGColor);
//
//
//
//
//    CGContextFillPath(ctx);
//
    
    
}


//重写绘图，调用刚才绘图的方法

-(void)drawRect:(CGRect)rect

{
    
//    CGRect frame = rect;
//
//    frame.size.width= frame.size.width -20;
//
//    rect = frame;
    
    //绘制带箭头的框框
    
    [self drawArrowRectangle:rect];
    
}

@end
