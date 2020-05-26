//
//  SLGlobalDefines.h
//  SLSDK
//
//  Created by songlei on 15/5/15.
//  Copyright (c) 2015年 songlei. All rights reserved.
//

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#ifndef SLGlobalDefines_h
#define SLGlobalDefines_h

#import "JSONKit.h"
#import "WCNetworkOperationProvider.h"
#import "WCBaseContext.h"


#import "UIDevice+Hardware.h"
#import "NSString+Extension.h"

#import "WCBaseConfiguration.h"
#import "WCPlistHelper.h"


#import "ASIHTTPRequest.h"
#import "ASIOperationWrapper.h"
#import "WCServiceBase_Test.h"


#pragma Pubilis .h

//#import "WCServiceBase.h"



#pragma mark UIConstants

/*
 * 内容区导航条高度  新的导航栏高度
 */
#define CONTENT_NAVIGATIONBAR_HEIGHT 44
#define CONTENT_TABBAR_HEIGHT 49

/*
 * 英文状态下键盘的高度
 */
#define PUBLISH_ENGISH_KEYBOARD_TOP 216.0


/*
 *屏幕宽度
 */
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)


/*
 *屏幕高度
 */

//#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height);

/*
 * iPhone statusbar 高度
 */
#define PHONE_STATUSBAR_HEIGHT 20


/*
 * iPhone 屏幕尺寸
 */
#define PHONE_SCREEN_SIZE (CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_STATUSBAR_HEIGHT))


#endif
