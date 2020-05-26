//
//  WJGlobalSingleton.h
//  ZJYLF
//
//  Created by 刘高洋 on 2018/6/13.
//  Copyright © 2018年 hymac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:60)
#define kNavBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#define PublicTabHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height>20?10:0)
#define WCStatusBarHeight 20
/*
 *屏幕宽度
 */
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

#define kWCScreenSize [[UIScreen mainScreen]bounds].size

#define   SCREEN_HEIGHT     [AppDelegate appDelegate].HEIGHT
//@{屏幕尺寸判断
/**
 *  判断是否为iphone4及其以下型号设备
 */
#define ISIPHONE4  ([UIScreen mainScreen].bounds.size.height < 481?YES:NO)


//判断iphone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone6+
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//}
// 导航栏返回按钮
#define  BackImage                         Image(@"newBack.png")


#ifdef DEBUG
#define TPLLOG            NSLog
#else
#define TPLLOG            TPLLog
#endif

//@{定义字体大小
#define   FontHugeSize                     20      // 消息正文标题 （专用）
#define   FontLargeSize                    18       // 导航栏      （常用）
#define   FontAlertSize                    16       // 操作提示框  （常用）
#define   FontNormalSize                   14       // 正文部分   （常用）
#define   FontSmallSize                    14       // 一般性文字  （最常用）
#define   FontSmallThanSmallSize           12       // 辅助文字    （一般）
#define   FontSmallSmallSize               10       // tab栏文字   （专用）
//}
//@{ 颜色设定
// 主题色- 用户导航栏、列表页、详情页等头部以及点击文字、高亮文字颜色
#define   MainBackColor                    BACKCOLOR(@"487DE5")
// 辅助色- 用于主标题、内页需要突出及强调文字
#define   DeepBlackTextColor               BACKCOLOR(@"333333")
// 辅助色- 用户警示性文字
#define   DeepReadTextColor                BACKCOLOR(@"f32f2a")
// 辅助色- 用于大段文字，提示性文字
#define   ContentTextColor                 BACKCOLOR(@"333333")
// 辅助色- 用于提示性文字，如文本框内提示性文字
#define   LightGrayTextColor               BACKCOLOR(@"c3c3c3")
// 辅助色- 用于分割线
#define   SepartorLineColor                BACKCOLOR(@"e2e5e9")
// 辅助色-用于背景区域
#define   ViewBackGroundColor              BACKCOLOR(@"eeeeee")
// 按钮不可用背景色
#define   ButtonEnableBackgroundColor      BACKCOLOR(@"e2e5e9")
// 按钮不可用文字颜色
#define   ButtonEnableTextColor            TEXTCOLOR(@"c6cace")
// 蓝色按钮背景色
#define   BlueButtonBackgroundColor        BACKCOLOR(@"2487df")
// 蓝色按钮点击状态背景色
#define   BlueButtonSelectBackColor        BACKCOLOR(@"56a2e5")
// 浅黑
#define   LightBlackTextColor              BACKCOLOR(@"666666")
// 深灰
#define   GrayTextColor                    BACKCOLOR(@"999999")
// 深色线颜色
#define   DeepLineColor                    BACKCOLOR(@"dddddd")
// 白色背景
#define   WhiteBackColor                   BACKCOLOR(@"ffffff")
//}
/*
 定义全局的NSUserDefault Key
 */
#define WJ_ACCOUNT_USER_HASLOGIN          @"WJ_ACCOUNT_USER_HASLOGIN"
#define WJ_ACCOUNT_USER_USERNAME          @"WJ_ACCOUNT_USER_USERNAME"
#define WJ_ACCOUNT_USER_MOBILE            @"WJ_ACCOUNT_USER_MOBILEE"
#define WJ_ACCOUNT_USER_PASSWORD          @"WJ_ACCOUNT_USER_PASSWORD"
#define WJ_ACCOUNT_USER_COMPANYID         @"WJ_ACCOUNT_USER_COMPANYID"
#define WJ_ACCOUNT_USER_ID                @"WJ_ACCOUNT_USER_ID"
#define WJ_ACCOUNT_FIRST_ENTER            @"define WJ_ACCOUNT_FIRST_ENTER"

@interface WJGlobalSingleton : NSObject
+ (WJGlobalSingleton *)sharedInstance;
// 是否登陆

@property (nonatomic, strong) WCOnbConfiguration *gWCOnbConfiguration;
@property (nonatomic, assign) BOOL hasLogin;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *firstEnterApp;

@end
