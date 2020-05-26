//
//  WJServiceBase.m
//  525JMobile
//
//  Created by iOS developer on 16/5/19.
//  Copyright © 2016年 song leilei. All rights reserved.
//

#import "WJServiceBase.h"
#import "WENetWorkPwd.h"
#import "WJWorkersRootViewController.h"
#import "NewAppointModel.h"
#import "NetworkCheckupgrade.h"
#import "WorkersAppDelegate.h"

@implementation WJServiceBase

- (void)showError:(NSError *)error {
    if (error.code == 999) {
        ShowMessage(@"没有网络", nil);
    }
}

/**
 * 版本号错误，进行版本升级
 */
- (void)updateVersion {
    [WJGlobalSingleton sharedInstance].hasLogin = NO;
    [WJGlobalSingleton sharedInstance].foremanid = @"";
    [DB clearTableData:[NewAppointModel class]];
    [WJGlobalSingleton sharedInstance].foremanpic = @"";
    [WJGlobalSingleton sharedInstance].employeeid = @"";
    [WJGlobalSingleton sharedInstance].md5key = @"";
    [WJGlobalSingleton sharedInstance].roleType = @0;
    
    WJWorkersRootViewController *rootViewController = (WJWorkersRootViewController*)[WorkersAppDelegate appDelegate].window.rootViewController;
    [rootViewController goToLoginViewController];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
       NotificationPost(@"NeedToUpdateVersion", nil, nil);
    });
}

/**
 * 用户名或密码错误，重新登录
 */
- (void)authenticationError {
    if ([WJGlobalSingleton sharedInstance].hasLogin) {
        [WJGlobalSingleton sharedInstance].hasLogin = NO;
        [WJGlobalSingleton sharedInstance].foremanid = @"";
        [DB clearTableData:[NewAppointModel class]];
        [WJGlobalSingleton sharedInstance].foremanpic = @"";
        [WJGlobalSingleton sharedInstance].employeeid = @"";
        [WJGlobalSingleton sharedInstance].md5key = @"";
        [WJGlobalSingleton sharedInstance].roleType = @0;
        
        WJWorkersRootViewController *rootViewController = (WJWorkersRootViewController*)[WorkersAppDelegate appDelegate].window.rootViewController;
        [rootViewController goToLoginViewController];
    }
}


- (void)checkPwd {
    NSString *targetName = [WJGlobalSingleton sharedInstance].gWCOnbConfiguration.group_name;
    if ([targetName isEqualToString:@"525JWorkersEnterprise"]) {
        if (![WJGlobalSingleton sharedInstance].hasLogin) {
            return ;
        }
        
        if (!isBlankString([WJGlobalSingleton sharedInstance].employeeid) &&
            !isBlankString([WJGlobalSingleton sharedInstance].md5key)) {
            WENetWorkPwd *pwd = [[WENetWorkPwd alloc] init];
            pwd.employeeid = [WJGlobalSingleton sharedInstance].employeeid;
            pwd.encryptdata = [WJGlobalSingleton sharedInstance].md5key;
            pwd.plantform = @"ios";
            pwd.apptype = @"enterprise";
            if ([[WCBaseContext sharedInstance].configuration.naviURL isEqualToString:@"http://test9.525j.com.cn"]) {
                pwd.currentversion = [WCBaseContext sharedInstance].configuration.buildNumber;
            } else {
                pwd.currentversion = [WCBaseContext sharedInstance].configuration.versionNumber;
            }
            [pwd startGetWithBlock:^(WENetWorkPwdResponse *result, NSError *error) {
                if ([result.code isEqualToString:@"200"]) {
                    if (result.data) {
                        if ([result.data[@"result"] boolValue]) {
                            if ([WJGlobalSingleton sharedInstance].hasLogin) {
                                [WJGlobalSingleton sharedInstance].hasLogin = NO;
                                [WJGlobalSingleton sharedInstance].foremanid = @"";
                                [DB clearTableData:[NewAppointModel class]];
                                [WJGlobalSingleton sharedInstance].foremanpic = @"";
                                [WJGlobalSingleton sharedInstance].employeeid = @"";
                                [WJGlobalSingleton sharedInstance].md5key = @"";
                                [WJGlobalSingleton sharedInstance].roleType = @0;
                                
                                WJWorkersRootViewController *rootViewController = (WJWorkersRootViewController*)[WorkersAppDelegate appDelegate].window.rootViewController;
                                [rootViewController goToLoginViewController];
                            }
                        }
                    }
                }
            }];
        } else {
            [WJGlobalSingleton sharedInstance].hasLogin = NO;
            [WJGlobalSingleton sharedInstance].foremanid = @"";
            [DB clearTableData:[NewAppointModel class]];
            [WJGlobalSingleton sharedInstance].foremanpic = @"";
            [WJGlobalSingleton sharedInstance].employeeid = @"";
            [WJGlobalSingleton sharedInstance].md5key = @"";
            [WJGlobalSingleton sharedInstance].roleType = @0;
            
            WJWorkersRootViewController *rootViewController = (WJWorkersRootViewController*)[WorkersAppDelegate appDelegate].window.rootViewController;
            [rootViewController goToLoginViewController];
        }
    }
}
@end
