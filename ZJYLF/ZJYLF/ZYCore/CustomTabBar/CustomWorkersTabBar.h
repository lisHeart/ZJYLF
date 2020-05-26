//
//  CustomTabBar.h
//  CustomTabBarController
//
//  Created by Hu Zhiqiang on 22/05/2012.
//  Copyright (c) 2012 __My Computer__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabBarDelegate;

@interface CustomWorkersTabBar : UIView
{
	NSMutableArray *_buttons;
    //id <CustomTabBarDelegate> _delegate;
}
@property (nonatomic, assign) id <CustomTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;

//- (id)initWithButtonImages:(NSArray *)imageArray;
- (id)initWithButtonImages:(NSArray *)imageArray titleArray:(NSArray*)titleArray;

- (void)selectTabAtIndex:(NSInteger)index;
- (void)tabBarButtonClicked:(id)sender;
@end

@protocol CustomTabBarDelegate<NSObject>
@optional
- (void)tabBar:(CustomWorkersTabBar *)tabBar didSelectIndex:(NSInteger)index; 
@end
