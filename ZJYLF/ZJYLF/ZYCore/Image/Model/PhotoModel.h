//
//  PhotoModel.h
//  HomeLove
//
//  Created by Stone on 15/8/12.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoModel : NSObject

/* mid，保存图片缓存唯一表示，必须传 */
@property (nonatomic, copy) NSString *mid;

/*
 * 网络图片
 * 图片地址
 */
@property (nonatomic, copy) NSString *image_url;

/** 高清图地址 */
@property (nonatomic, copy) NSString *image_HD;

/* 本地高清图片 */
@property (nonatomic, strong) UIImage *fullResolutionImage;

/* 本地全屏图片 */
@property (nonatomic, strong) UIImage *fullScreenImage;

/* 本地图片海报 */
@property (nonatomic, strong) UIImage *posterImage;

/* 本地图片路径 */
@property (nonatomic, copy) NSString *filePath;

/* 是否为网络图片 */
@property (nonatomic, assign) BOOL isNetWork;

/*! 默认图片 */
@property (nonatomic, strong) UIImage *defaultImage;

/*! 图片大小 byte */
@property (nonatomic, strong) NSNumber *bytes;
/*! 图片大小 M */
@property (nonatomic, copy) NSString *bigBytes;
@end
