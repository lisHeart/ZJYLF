//
//  PhotoImageView.m
//  HomeLove
//
//  Created by Stone on 15/8/12.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import "PhotoImageView.h"

@interface PhotoImageView ()

@property (nonatomic, assign) CGRect screenBounds;

@property (nonatomic, assign) CGPoint screenCenter;

@end

@implementation PhotoImageView

- (void)setImage:(UIImage *)image
{
    if (image == nil) {
        [super setImage:nil];
        
        return ;
    }
    
    [super setImage:image];
    
    [self calFrame];
    
    self.contentMode = UIViewContentModeScaleAspectFill;
}

/*
 *  确定frame
 */
- (void) calFrame
{
    CGSize size = self.image.size;
    
    // 首先判断缩放的值
    float scaleX = [[UIScreen mainScreen] bounds].size.width / size.width;
    
    float imgViewWidth = 0.0f;
    float imgViewHeight = 0.0f;
    
    imgViewWidth = floorf(size.width * scaleX);
    imgViewHeight = floorf(size.height * scaleX);
    
    CGRect frame = [self frameWithW:imgViewWidth h:imgViewHeight center:self.screenCenter];
    
    self.calF = frame;
}

- (CGRect)frameWithW:(CGFloat)w h:(CGFloat)h center:(CGPoint)center
{
    CGFloat x = center.x - w *.5f;
    CGFloat y = center.y - h * .5f;
    CGRect frame = (CGRect){CGPointMake(x, y),CGSizeMake(w, h)};
    
    return frame;
}

- (CGRect)screenBounds
{
    if (CGRectEqualToRect(_screenBounds, CGRectZero)) {
        
        _screenBounds = [UIScreen mainScreen].bounds;
        
    }
    
    return _screenBounds;
}

- (CGPoint)screenCenter
{
    if (CGPointEqualToPoint(_screenCenter, CGPointZero)) {
        CGSize size = self.screenBounds.size;
        _screenCenter = CGPointMake(size.width * .5f, size.height * .5);
    }
    
    return _screenCenter;
}
@end



