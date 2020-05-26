//
//  AppDelegate.h
//  test
//
//  Created by hymac on 2017/5/8.
//  Copyright © 2017年 hymac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
+(AppDelegate *)appDelegate;
+ (void)hiddentabBar:(BOOL)hidden isAnimat:(BOOL)isAnimat;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign, readonly) CGFloat HEIGHT;

@end

