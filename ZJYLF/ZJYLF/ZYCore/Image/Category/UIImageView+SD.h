//
//  UIImageView+SD.h
//  ImageAction
//
//  Created by Stone on 15/8/11.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "UIImage+ReMake.h"

@interface UIImageView (SD)

/**
 * 普通网络图片展示
 *
 * @param urlStr   图片地址
 * @param phImage  占位图片
 */
- (void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage;

/**
 * 带有进度的网络图片展示
 *
 * @param urlStr           图片地址
 * @param phImage          占位图片
 * @param progressBlock    进度
 * @param completedBlock   完成
 */
- (void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage progressBlock:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageCompletionBlock)completedBlock;

@end
