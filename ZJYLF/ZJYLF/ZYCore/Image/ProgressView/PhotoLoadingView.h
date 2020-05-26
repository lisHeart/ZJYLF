//
//  PhotoLoadingView.h
//  525JMobile
//
//  Created by iOS developer on 15/10/14.
//  Copyright (c) 2015年 song leilei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinProgress 0.0001

@interface PhotoLoadingView : UIView
@property (nonatomic, assign) float progress;

- (void)showLoading;
@end
