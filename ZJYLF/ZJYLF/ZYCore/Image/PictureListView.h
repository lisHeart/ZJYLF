//
//  PictureListController.h
//  HomeLove
//
//  Created by Stone on 15/8/12.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMaxImageCount      12

typedef enum {
    List,           // 列表，从网络下载图片
    Add,            // 本地添加图片
    Edit            // 编辑
}PictureType;

@protocol PictureListViewDelegate <NSObject>

- (void)tapPicture;

@end

@interface PictureListView : UIView

@property (nonatomic, weak) id<PictureListViewDelegate> delegate;

@property (nonatomic, assign) BOOL isEidt;

@property (nonatomic, assign) PictureType type;

@property (nonatomic, strong) NSArray *picts;

@property (nonatomic, strong) NSMutableArray *finalImages;

// 最多允许图片数量
@property (nonatomic, assign) int maxCount;
// 现在已有图片数量
@property (nonatomic, assign) int currentCount;

@property (nonatomic, strong) NSMutableArray *imagesArray;

// Modal view Controller
@property (nonatomic, strong) id modalController;

- (id)init;

- (void)setContrllerFrame:(CGRect)frame;

@end
