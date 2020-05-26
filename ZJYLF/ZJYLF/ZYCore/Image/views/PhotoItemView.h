//
//  PhotoItemView.h
//  HomeLove
//
//  Created by Stone on 15/8/12.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPictureController.h"
#import "PhotoImageView.h"
#import "PhotoModel.h"

@protocol PhotoItemViewDelegate <NSObject>

@optional
- (void)dismissView;

@end

@interface PhotoItemView : UIView

@property (nonatomic, weak) id<PhotoItemViewDelegate> delegate;

@property (nonatomic, assign) ShowType type;

/* 数据模型 */
@property (nonatomic, strong) PhotoModel *photoModel;

/* 当前缩放比例 */
@property (nonatomic, assign) CGFloat zoomScale;

/*
 * 当前页标 
 */
@property (nonatomic, assign) NSUInteger pageIndex;

@property (nonatomic, strong) PhotoImageView *photoImageView;

@property (nonatomic, strong) NSString *url;

/*
 * 重置
 */
- (void)reset;
@end
