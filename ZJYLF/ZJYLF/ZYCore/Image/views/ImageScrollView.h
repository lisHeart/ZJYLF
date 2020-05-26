//
//  ImageScrollView.h
//  HomeLove
//
//  Created by Stone on 15/8/12.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView

@property (nonatomic, assign) NSUInteger index;

/** 照片数组 */
@property (nonatomic, strong) NSArray *photoModels;
@end
