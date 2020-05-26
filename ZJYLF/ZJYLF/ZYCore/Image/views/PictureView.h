//
//  PictureVIew.h
//  HomeLove
//
//  Created by Stone on 15/8/12.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ReMake.h"
#import "UIImageView+SD.h"
#import "PBGView.h"

@interface PictureView : UIImageView

@property (nonatomic, assign) BOOL hasImage;

@property (nonatomic, assign) int  index;
// 是否为网络图片
@property (nonatomic, assign) BOOL isFromInternet;

@property (nonatomic, strong) PBGView *progressView;
// 默认图片
@property (nonatomic, strong) UIImage *defatultImage;
// 下载获得图片
@property (nonatomic, strong) UIImage *originalImage;
// 图片地址(网路图片url)
@property (nonatomic, copy)   NSString *url;
// 是否展示现在百分比
@property (nonatomic, assign) BOOL isNotShow;
@end
