//
//  UIImage+ReMake.h
//  ImageAction
//
//  Created by Stone on 15/8/11.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ReMake)

- (UIImage *)remakeImageWithFullSize:(CGSize)fullSize zoom:(CGFloat)zoom;

/*
 * 生成一个默认的占位图片：
 */
+ (UIImage *)image:(UIImage *)image phImageWithSize:(CGSize)fullSize zoom:(CGFloat)zoom;
@end
