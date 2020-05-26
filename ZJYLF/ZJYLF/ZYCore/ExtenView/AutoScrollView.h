//
//  AutoScrollView.h
//  BlueMobiProject
//
//  Created by iOS developer on 15/9/24.
//  Copyright (c) 2015年 iOS developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  AutoScrollViewDelegate;

@interface AutoScrollView : UIView <UIScrollViewDelegate>
{
    UIView *firstView;
    UIView *middleView;
    UIView *lastView;
}

@property (nonatomic, readonly) UIScrollView  *scrollView;
@property (nonatomic, readonly) UIPageControl  *pageControl;
@property (nonatomic, assign)   NSInteger      currentPage;
@property (nonatomic, strong)   NSMutableArray *viewsArray;
@property (nonatomic, assign)   NSTimeInterval autoScrollDelayTime;

@property (nonatomic, weak) id<AutoScrollViewDelegate> delegate;

//自动滚动，界面不在的时候调用此方法传NO，停止timer
-(void)shouldAutoShow:(BOOL)shouldStart;

@end

@protocol AutoScrollViewDelegate <NSObject>

@optional

- (void)didClickPage:(AutoScrollView *)view atIndex:(NSInteger)index;

@end
