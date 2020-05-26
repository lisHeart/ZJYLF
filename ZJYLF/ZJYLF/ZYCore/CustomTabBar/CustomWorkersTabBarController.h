//
//  CustomTabBarController.h
//  CustomTabBarController
//
//  Created by Hu Zhiqiang on 22/05/2012.
//  Copyright (c) 2012 __My Computer__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomWorkersTabBar.h"

@protocol ChangeIndexDelegate;

@interface CustomWorkersTabBarController : UIViewController <CustomTabBarDelegate>{
	CustomWorkersTabBar        *_tabBar;
	UIView          *_containerView;    // 容器
	UIView          *_transitionView;   // 过渡
    UIView          *selectedView;
	NSMutableArray  *_viewControllers;  
	NSUInteger      _selectedIndex;
}
@property(nonatomic, copy) NSMutableArray *viewControllers;
@property(nonatomic, readonly) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;
@property (nonatomic, retain) CustomWorkersTabBar *tabBar;
@property (nonatomic, weak) id <ChangeIndexDelegate> changeIndexDelegate;
@property (nonatomic, strong) UIImageView *messageUnreadPrompt;                 //消息图标上的小红点

//- (id)initWithViewControllers:(NSArray *)controllers imageArray:(NSArray *)images;
- (id)initWithViewControllers:(NSArray *)controllers imageArray:(NSArray *)images titleArray:(NSArray*)titleArray;
- (void)hiddentabBar:(BOOL)hidden isAnimat:(BOOL)isAnimat;

- (void)showBadgeOnItemIndex:(int)index;  //显示小红点
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end

@protocol ChangeIndexDelegate<NSObject>
@optional
- (void)customTabBar:(CustomWorkersTabBarController *)tabBar didSelectIndex:(NSInteger)index;
@end

