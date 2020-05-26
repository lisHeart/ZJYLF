//
//  PhotoLoadingView.m
//  525JMobile
//
//  Created by iOS developer on 15/10/14.
//  Copyright (c) 2015年 song leilei. All rights reserved.
//

#import "PhotoLoadingView.h"
#import "PhotoProgressView.h"

@interface PhotoLoadingView ()
{
    PhotoProgressView *_progressView;
}
@end

@implementation PhotoLoadingView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (void)showLoading
{
    if (_progressView == nil) {
        _progressView = [[PhotoProgressView alloc] init];
        _progressView.bounds = CGRectMake(0, 0, 60, 60);
        _progressView.center = self.center;
    }
    _progressView.progress = kMinProgress;
    [self addSubview:_progressView];
}

#pragma mark -
#pragma mark customlize method
- (void)setProgress:(float)progress
{
    _progress = progress;
    _progressView.progress = progress;
    if (progress >= 1.0) {
        [_progressView removeFromSuperview];
    }
}
@end
