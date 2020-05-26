//
//  ShowPictureController.h
//  HomeLove
//
//  Created by Stone on 15/8/12.
//  Copyright (c) 2015年 Stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureVIew.h"

typedef enum {
    Show,             // 展示图片
    Delete            // 删除
}ShowType;

@protocol ShowPictureControllerDelegate <NSObject>

@optional
- (void)finishWithImages:(NSArray *)images;
@end

@interface ShowPictureController : UIViewController

@property (nonatomic, weak) id<ShowPictureControllerDelegate> delegate;

- (void)show:(UIViewController *)handleVC type:(ShowType)type isInternet:(BOOL)flag index:(NSUInteger)index photoViews:(NSArray *)photos;

@end
