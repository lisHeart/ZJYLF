//
//  AppDelegate.m
//  test
//
//  Created by hymac on 2017/5/8.
//  Copyright © 2017年 hymac. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ZJHeadViewController.h"
#import "ZJPersonCenterViewController.h"
#import "CustomWorkersTabBarController.h"
#import "ZJLoginViewController.h"
#import "ZJApplyViewController.h"
#import "NetWorkForDownloadAdd.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate *)appDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    UITabBarController * tabbarVC = [[UITabBarController alloc]init];
    //园区首页
    ZJTaskPursueViewController *headVC = [[ZJTaskPursueViewController alloc] init];
    UINavigationController *nav_head = [[UINavigationController alloc]initWithRootViewController:headVC];
    nav_head.navigationBarHidden = YES;
    nav_head.tabBarItem.image = [UIImage imageNamed:@"园区资讯-未选中"];
    nav_head.tabBarItem.selectedImage = [UIImage imageNamed:@"园区资讯-选中"];
    nav_head.view.backgroundColor = [UIColor clearColor];
    nav_head.tabBarItem.title = @"园区咨询";
    [tabbarVC addChildViewController:nav_head];
    
    
    //任务追踪
    ZJApplyViewController *taskVc = [[ZJApplyViewController alloc] init];
    UINavigationController *nav_task = [[UINavigationController alloc] initWithRootViewController:taskVc];
    nav_task.navigationBarHidden = YES;
    nav_task.tabBarItem.image = [UIImage imageNamed:@"服务申请-未选中"];
    nav_task.tabBarItem.selectedImage = [UIImage imageNamed:@"服务申请-未选中"];
    nav_task.view.backgroundColor = [UIColor clearColor];
    nav_task.tabBarItem.title = @"服务申请";
    [tabbarVC addChildViewController:nav_task];
    
    //个人中心
    UINavigationController *nav_person ;

    HomeViewController *personVC = [[HomeViewController alloc] init];
    nav_person = [[UINavigationController alloc] initWithRootViewController:personVC];
    nav_person.tabBarItem.image = [UIImage imageNamed:@"个人中心"];
    nav_person.tabBarItem.selectedImage = [UIImage imageNamed:@"个人中心-选中状态"];
    nav_person.view.backgroundColor = [UIColor clearColor];
    nav_person.tabBarItem.title = @"个人中心";
    [tabbarVC addChildViewController:nav_person];
    nav_person.navigationBarHidden = YES;


//    HomeViewController *homeVC = [[HomeViewController alloc] init];
    self.window.rootViewController = tabbarVC;
    [self.window makeKeyAndVisible];
    [[WCBaseContext sharedInstance] startupWithConfiguration:[WJGlobalSingleton sharedInstance].gWCOnbConfiguration];
    
    //统计下载量
    [self recodeAppDownload];
    return YES;
}
- (CGFloat) HEIGHT {
    if ([UIApplication sharedApplication].statusBarFrame.size.height == 40.0f) {
        return [[UIScreen mainScreen] bounds].size.height - 20;
    } else {
        return [[UIScreen mainScreen] bounds].size.height;
    }
}

- (void)recodeAppDownload{
    if (![[WJGlobalSingleton sharedInstance].firstEnterApp isEqualToString:@"1"]) {
        [WJGlobalSingleton sharedInstance].firstEnterApp = @"1";
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        NetWorkForDownloadAdd *net = [[NetWorkForDownloadAdd alloc] init];
        DownloadAddPostmodel *model = [[DownloadAddPostmodel alloc] init];
        model.platform = @"ios";
        model.deviceid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        model.appversion = app_Version;
        
        net.postModel = model;
        
        [net startPostWithBlock:^(DownloadAddRespone *result, NSError *error) {
            
        }];
        
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
