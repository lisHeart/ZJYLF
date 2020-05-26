//
//  ImageBO.h
//  BlueMobiProject
//
//  Created by iOS developer on 15/9/22.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//

#import "LKDaoBase.h"

@interface ImageBO : LKModelBase


/*
 * 网络图片
 * 图片地址
 */
@property (nonatomic, copy) NSString *image_url;

/* 本地图片路径 */
@property (nonatomic, copy) NSString *filePath;

@end
