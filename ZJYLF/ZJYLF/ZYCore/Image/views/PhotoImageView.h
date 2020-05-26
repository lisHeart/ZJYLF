//
//  PhotoImageView.h
//  HomeLove
//
//  Created by Stone on 15/8/12.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoImageView : UIImageView

/*
 * 设置照片后的回调
 */
@property (nonatomic,copy) void (^ImageSetBlock)(UIImage *image);

@property (nonatomic, assign) CGRect calF;

@end
